#!/usr/bin/env python3
"""Spotify popup — Wayland layer-shell overlay with album art and controls."""
import subprocess, threading, urllib.request, tempfile, os

import popup_base as pb
from gi.repository import Gtk, Gdk, GLib, GdkPixbuf

pb.kill_other_popups('spotify-popup.py')

# ── playerctl helpers ─────────────────────────────────────────────────────────

def pctl(*args):
    try:
        return subprocess.check_output(
            ['playerctl', '--player=spotify', *args],
            text=True, stderr=subprocess.DEVNULL
        ).strip()
    except Exception:
        return ''

def get_meta():
    result = {}
    for k in ['title', 'artist', 'album', 'mpris:artUrl', 'mpris:length']:
        result[k.split(':')[-1]] = pctl('metadata', k)
    try:
        result['pos']      = int(float(pctl('position')))
        raw                = result.get('length', '0')
        result['duration'] = int(raw) // 1_000_000 if raw else 0
    except Exception:
        result['pos'] = result['duration'] = 0
    result['status'] = pctl('status')
    return result

def fmt(secs):
    try:
        s = int(secs)
        return f'{s//60}:{s%60:02d}'
    except Exception:
        return '0:00'

ART_SIZE = 140


class SpotifyOverlay(pb.OverlayPopup):
    POPUP_W = 380
    # custom/media module label always contains the spotify glyph (or the default note fallback)
    ANCHOR_MATCH = ('', '🎜')
    EXTRA_CSS = b"""
    label#title  { color: #e0def4; font-weight: 700; font-size: 14px; }
    label#artist { color: #908caa; font-size: 12px; }
    label#album  { color: #6e6a86; font-size: 11px; font-style: italic; }
    label#time   { color: #908caa; font-size: 11px; }
    scale trough      { background-color: #393552; min-height: 4px; border-radius: 4px; }
    scale highlight   { background-color: #3e8fb0; border-radius: 4px; }
    scale slider      { background-color: #e0def4; min-width: 11px; min-height: 11px;
                        border-radius: 50%; margin: -4px 0; border: none; box-shadow: none; }
    scale slider:hover { background-color: #ea9a97; }
    button.ctrl {
      font-family: "Symbols Nerd Font", "CommitMono";
      background-color: transparent; border: none; border-radius: 8px;
      color: #908caa; font-size: 18px; padding: 6px 12px; min-width: 40px;
    }
    button.ctrl:hover { background-color: rgba(87,82,110,0.5); color: #e0def4; }
    button#play       { color: #c4a7e7; font-size: 22px; }
    button#play:hover { color: #e0def4; }
    """

    def __init__(self):
        self._meta = get_meta()
        self._dragging = False
        super().__init__()
        GLib.timeout_add(1000, self._tick)
        art_url = self._meta.get('artUrl', '')
        if art_url:
            threading.Thread(target=self._load_art, args=(art_url,), daemon=True).start()

    # ── Popup content ─────────────────────────────────────────────────────────

    def build_popup(self):
        m   = self._meta
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12)

        top = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=14)
        box.pack_start(top, False, False, 0)

        self._art = Gtk.Image()
        self._art.set_size_request(ART_SIZE, ART_SIZE)
        self._set_placeholder_art()
        top.pack_start(self._art, False, False, 0)

        info = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=4)
        info.set_valign(Gtk.Align.CENTER)
        top.pack_start(info, True, True, 0)

        self._title  = Gtk.Label(label=m.get('title', '—'), xalign=0)
        self._artist = Gtk.Label(label=m.get('artist', ''), xalign=0)
        self._album  = Gtk.Label(label=m.get('album', ''), xalign=0)
        self._title.set_name('title');  self._title.set_line_wrap(True); self._title.set_max_width_chars(20)
        self._artist.set_name('artist')
        self._album.set_name('album')
        for w in (self._title, self._artist, self._album):
            info.pack_start(w, False, False, 0)

        prog = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=2)
        box.pack_start(prog, False, False, 0)

        self._scale = Gtk.Scale.new_with_range(
            Gtk.Orientation.HORIZONTAL, 0, max(1, m.get('duration', 1)), 1)
        self._scale.set_value(m.get('pos', 0))
        self._scale.set_draw_value(False)
        self._scale.set_hexpand(True)
        self._scale.connect('button-press-event',   lambda *_: setattr(self, '_dragging', True))
        self._scale.connect('button-release-event', self._on_seek)
        pb.use_pointer_cursor(self._scale, drag_cursor='grabbing')
        prog.pack_start(self._scale, False, False, 0)

        time_row = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)
        self._pos_lbl = Gtk.Label(label=fmt(m.get('pos', 0)), xalign=0)
        self._dur_lbl = Gtk.Label(label=fmt(m.get('duration', 0)), xalign=1)
        self._pos_lbl.set_name('time'); self._dur_lbl.set_name('time')
        time_row.pack_start(self._pos_lbl, True, True, 0)
        time_row.pack_start(self._dur_lbl, True, True, 0)
        prog.pack_start(time_row, False, False, 0)

        ctrl = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
        ctrl.set_halign(Gtk.Align.CENTER)
        box.pack_start(ctrl, False, False, 0)

        self._prev_btn = self._btn('', self._prev, 'ctrl')
        status = m.get('status', '')
        self._play_btn = self._btn('' if status == 'Playing' else '', self._play_pause, 'ctrl', name='play')
        self._next_btn = self._btn('', self._next, 'ctrl')
        for b in (self._prev_btn, self._play_btn, self._next_btn):
            ctrl.pack_start(b, False, False, 0)

        return box

    def _btn(self, label, cb, css_class, name=None):
        b = Gtk.Button(label=label)
        b.get_style_context().add_class(css_class)
        if name:
            b.set_name(name)
        b.connect('clicked', lambda _: cb())
        pb.use_pointer_cursor(b)
        return b

    def _set_placeholder_art(self):
        pb_ = GdkPixbuf.Pixbuf.new(GdkPixbuf.Colorspace.RGB, False, 8, ART_SIZE, ART_SIZE)
        pb_.fill(0x393552ff)
        self._art.set_from_pixbuf(pb_)

    def _load_art(self, url):
        try:
            tmp = tempfile.NamedTemporaryFile(suffix='.jpg', delete=False)
            urllib.request.urlretrieve(url, tmp.name)
            def update():
                try:
                    pxb = GdkPixbuf.Pixbuf.new_from_file_at_scale(tmp.name, ART_SIZE, ART_SIZE, True)
                    self._art.set_from_pixbuf(pxb)
                except Exception:
                    pass
                finally:
                    try: os.unlink(tmp.name)
                    except Exception: pass
                return False
            GLib.idle_add(update)
        except Exception:
            pass

    # ── Controls ──────────────────────────────────────────────────────────────

    def _prev(self):       subprocess.run(['playerctl', '--player=spotify', 'previous'])
    def _next(self):       subprocess.run(['playerctl', '--player=spotify', 'next'])
    def _play_pause(self):
        subprocess.run(['playerctl', '--player=spotify', 'play-pause'])
        GLib.timeout_add(150, self._refresh)

    def _on_seek(self, scale, _):
        self._dragging = False
        subprocess.run(['playerctl', '--player=spotify', 'position', str(int(scale.get_value()))])

    # ── Refresh ───────────────────────────────────────────────────────────────

    def _tick(self):
        self._refresh()
        return True

    def _refresh(self):
        m = get_meta(); self._meta = m
        self._title.set_text(m.get('title', '—'))
        self._artist.set_text(m.get('artist', ''))
        self._album.set_text(m.get('album', ''))
        dur = max(1, m.get('duration', 1)); pos = m.get('pos', 0)
        self._scale.set_range(0, dur)
        if not self._dragging:
            self._scale.set_value(pos)
        self._pos_lbl.set_text(fmt(pos)); self._dur_lbl.set_text(fmt(dur))
        self._play_btn.set_label('' if m.get('status') == 'Playing' else '')

    # ── Events ────────────────────────────────────────────────────────────────

    def _on_key(self, _, ev):
        k = ev.keyval
        if k in (Gdk.KEY_Escape, Gdk.KEY_q): Gtk.main_quit()
        elif k == Gdk.KEY_space:  self._play_pause()
        elif k == Gdk.KEY_Left:   self._prev()
        elif k == Gdk.KEY_Right:  self._next()


def main():
    if not pctl('status'):
        return
    pb.run(SpotifyOverlay)

if __name__ == '__main__':
    main()
