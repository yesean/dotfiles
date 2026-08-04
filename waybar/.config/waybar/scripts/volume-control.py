#!/usr/bin/env python3
"""Volume control popup — Wayland layer-shell overlay, click outside closes."""
import subprocess

import popup_base as pb
from gi.repository import Gtk

pb.kill_other_popups('volume-control.py')

# ── PulseAudio helpers ────────────────────────────────────────────────────────

def pactl(*args):
    return subprocess.check_output(['pactl', *args], text=True).strip()

def get_vol(kind):
    cmd = f'get-{"sink" if kind=="out" else "source"}-volume'
    target = '@DEFAULT_SINK@' if kind == 'out' else '@DEFAULT_SOURCE@'
    try:
        return int(pactl(cmd, target).split('%')[0].split()[-1])
    except Exception:
        return 50

def get_mute(kind):
    cmd = f'get-{"sink" if kind=="out" else "source"}-mute'
    target = '@DEFAULT_SINK@' if kind == 'out' else '@DEFAULT_SOURCE@'
    try:
        return 'yes' in pactl(cmd, target)
    except Exception:
        return False

def set_vol(kind, v):
    cmd = 'set-sink-volume' if kind == 'out' else 'set-source-volume'
    target = '@DEFAULT_SINK@' if kind == 'out' else '@DEFAULT_SOURCE@'
    subprocess.run(['pactl', cmd, target, f'{int(v)}%'])

def toggle_mute(kind):
    cmd = 'set-sink-mute' if kind == 'out' else 'set-source-mute'
    target = '@DEFAULT_SINK@' if kind == 'out' else '@DEFAULT_SOURCE@'
    subprocess.run(['pactl', cmd, target, 'toggle'])


class VolumeOverlay(pb.OverlayPopup):
    POPUP_W = 320
    # pulseaudio module label always contains a volume/mute glyph + '%'
    ANCHOR_MATCH = ('', '', '', '', '󰍬', '󰍭')
    EXTRA_CSS = b"""
    label.section {
      color:         #908caa;
      font-size:     11px;
      font-weight:   600;
      margin-bottom: 4px;
    }
    label.icon {
      font-family: "Symbols Nerd Font", "CommitMono";
      color:       #e0def4;
      font-size:   16px;
      min-width:   28px;
    }
    button.mute {
      font-family:      "Symbols Nerd Font", "CommitMono";
      background-color: #393552;
      border-radius:    8px;
      border:           none;
      padding:          5px 11px;
      color:            #908caa;
      font-size:        14px;
      min-width:        36px;
    }
    button.mute.muted {
      background-color: rgba(235,111,146,0.22);
      color:            #eb6f92;
    }
    button.mute:hover { background-color: #44415a; }
    scale trough {
      background-color: #393552;
      min-height:       4px;
      border-radius:    4px;
    }
    scale highlight {
      background-color: #3e8fb0;
      border-radius:    4px;
    }
    scale slider {
      background-color: #e0def4;
      min-width:  13px; min-height: 13px;
      border-radius: 50%;
      margin: -5px 0;
      box-shadow: none; border: none;
    }
    scale slider:hover { background-color: #ea9a97; }
    separator.divider {
      margin: 32px 0;
    }
    """

    def build_popup(self):
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
        box.pack_start(self._section('OUTPUT', '', 'out'), False, False, 0)
        sep = Gtk.Separator()
        sep.get_style_context().add_class('divider')
        box.pack_start(sep, False, False, 0)
        box.pack_start(self._section('INPUT', '\U000f036c', 'in'), False, False, 0)
        return box

    def _section(self, title, icon_chr, kind):
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=4)

        lbl = Gtk.Label(label=title, xalign=0)
        lbl.get_style_context().add_class('section')
        box.pack_start(lbl, False, False, 0)

        row = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)

        icon = Gtk.Label(label=icon_chr)
        icon.get_style_context().add_class('icon')
        row.pack_start(icon, False, False, 0)

        scale = Gtk.Scale.new_with_range(Gtk.Orientation.HORIZONTAL, 0, 100, 1)
        scale.set_value(get_vol(kind))
        scale.set_draw_value(False)
        scale.set_hexpand(True)
        scale.connect('value-changed', lambda s, k=kind: set_vol(k, s.get_value()))
        pb.use_pointer_cursor(scale, drag_cursor='grabbing')
        row.pack_start(scale, True, True, 0)

        muted = get_mute(kind)
        off_icon = '' if kind == 'out' else '\U000f036c'
        on_icon  = '' if kind == 'out' else '󰍭'
        btn = Gtk.Button(label=on_icon if muted else off_icon)
        btn.get_style_context().add_class('mute')
        if muted:
            btn.get_style_context().add_class('muted')

        def on_mute(b, k=kind, on=on_icon, off=off_icon):
            toggle_mute(k)
            now = get_mute(k)
            b.set_label(on if now else off)
            ctx = b.get_style_context()
            (ctx.add_class if now else ctx.remove_class)('muted')

        btn.connect('clicked', on_mute)
        pb.use_pointer_cursor(btn)
        row.pack_start(btn, False, False, 0)
        box.pack_start(row, False, False, 0)
        return box


if __name__ == '__main__':
    pb.run(VolumeOverlay)
