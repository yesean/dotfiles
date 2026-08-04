#!/usr/bin/env python3
"""WiFi selector — Wayland layer-shell overlay, nmcli-backed."""
import subprocess, threading

import popup_base as pb
from gi.repository import Gtk, Gdk, GLib

pb.kill_other_popups('wifi-menu.py')

WIFI_ICON = ''


def sh(*args):
    try:
        return subprocess.check_output(args, text=True).strip()
    except Exception:
        return ''


def wifi_enabled():
    lines = sh('nmcli', '-t', '-f', 'WIFI', 'radio').splitlines()
    return bool(lines) and lines[0] == 'enabled'


def current_ssid():
    # NB: "dev wifi" without the "list" verb triggers a fresh rescan (~2s);
    # "dev wifi list" reuses NetworkManager's cache and returns instantly.
    for line in sh('nmcli', '-t', '-f', 'active,ssid', 'dev', 'wifi', 'list').splitlines():
        parts = line.split(':', 1)
        if len(parts) == 2 and parts[0] == 'yes':
            return parts[1]
    return ''


def list_networks():
    seen = set()
    nets = []
    out = sh('nmcli', '--colors', 'no', '-t', '-f', 'ssid,signal,security', 'dev', 'wifi', 'list')
    for line in out.splitlines():
        parts = line.split(':')
        if len(parts) < 3 or not parts[0] or parts[0] in seen:
            continue
        seen.add(parts[0])
        try:
            signal = int(parts[1])
        except Exception:
            signal = 0
        secured = parts[2] not in ('', '--')
        nets.append((parts[0], signal, secured))
    nets.sort(key=lambda n: -n[1])
    return nets[:15]


def signal_bars(signal):
    if signal > 75: return ''
    if signal > 50: return ''
    if signal > 25: return ''
    return ''


class WifiMenu(pb.OverlayPopup):
    POPUP_W = 380
    ANCHOR_MATCH = (WIFI_ICON, 'Disconnected')
    EXTRA_CSS = b"""
    label.ssid     { color: #e0def4; font-size: 13px; }
    label.ssid-cur { color: #ea9a97; font-size: 13px; font-weight: 700; }
    label.bars     { font-family: "Symbols Nerd Font"; color: #3e8fb0; font-size: 13px; min-width: 20px; }
    label.lock     { color: #908caa; font-size: 12px; min-width: 16px; }
    button.netrow {
      font-family:      "CommitMono", "Symbols Nerd Font", sans-serif;
      background-color: transparent;
      background-image: none;
      border:           none;
      color:            #e0def4;
      padding:          6px 8px;
      border-radius:    8px;
    }
    button.netrow:hover { background-color: rgba(87,82,110,0.5); }
    button.toggle {
      font-family:      "CommitMono", "Symbols Nerd Font", sans-serif;
      background-color: #393552;
      background-image: none;
      border-radius:    8px;
      border:           none;
      padding:          6px 12px;
      color:            #e0def4;
      font-size:        12px;
    }
    button.toggle:hover { background-color: #44415a; }
    entry.pass {
      font-family:      "CommitMono", "Symbols Nerd Font", sans-serif;
      background-color: #393552;
      background-image: none;
      border-radius:    8px;
      border:           none;
      padding:          6px 10px;
      color:            #e0def4;
    }
    label.err     { color: #eb6f92; font-size: 11px; }
    label.loading { color: #908caa; font-size: 12px; }
    spinner {
      color: #ea9a97;
      min-width:  16px;
      min-height: 16px;
    }
    """

    def build_popup(self):
        self._box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
        self._show_loading('Loading networks…')
        GLib.idle_add(self._load_async)
        return self._box

    def _clear(self):
        for child in self._box.get_children():
            self._box.remove(child)

    def _show_loading(self, text):
        self._clear()
        box = self._box
        box.pack_start(self.header('WIFI'), False, False, 0)

        row = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=8)
        spinner = Gtk.Spinner()
        spinner.start()
        row.pack_start(spinner, False, False, 0)
        lbl = Gtk.Label(label=text, xalign=0)
        lbl.get_style_context().add_class('loading')
        row.pack_start(lbl, False, False, 0)
        box.pack_start(row, False, False, 10)
        box.show_all()

    def _load_async(self):
        def worker():
            enabled = wifi_enabled()
            cur = current_ssid() if enabled else ''
            nets = list_networks() if enabled else []
            GLib.idle_add(self._show_list, enabled, cur, nets)
        threading.Thread(target=worker, daemon=True).start()
        return False

    def _show_list(self, enabled, cur, nets):
        self._clear()
        box = self._box

        box.pack_start(self.header('WIFI'), False, False, 0)

        toggle_btn = Gtk.Button(label='  Disable WiFi' if enabled else '  Enable WiFi')
        toggle_btn.get_style_context().add_class('toggle')
        toggle_btn.connect('clicked', self._on_toggle)
        pb.use_pointer_cursor(toggle_btn)
        box.pack_start(toggle_btn, False, False, 4)

        if not enabled:
            box.show_all()
            return False

        netlist = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=2)
        for ssid, signal, secured in nets:
            r = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)

            bars = Gtk.Label(label=signal_bars(signal))
            bars.get_style_context().add_class('bars')
            r.pack_start(bars, False, False, 0)

            lock = Gtk.Label(label='\uf023' if secured else '')
            lock.get_style_context().add_class('lock')
            r.pack_start(lock, False, False, 0)

            name = Gtk.Label(label=('\u25b6 ' if ssid == cur else '') + ssid, xalign=0)
            name.get_style_context().add_class('ssid-cur' if ssid == cur else 'ssid')
            r.pack_start(name, True, True, 0)

            btn = Gtk.Button()
            btn.add(r)
            btn.set_relief(Gtk.ReliefStyle.NONE)
            btn.get_style_context().add_class('netrow')
            btn.connect('clicked', self._on_network_clicked, ssid, secured, cur)
            pb.use_pointer_cursor(btn)
            netlist.pack_start(btn, False, False, 0)

        box.pack_start(netlist, False, False, 4)
        box.show_all()
        return False

    def _on_toggle(self, _btn):
        enabled = wifi_enabled()
        subprocess.run(['nmcli', 'radio', 'wifi', 'off' if enabled else 'on'])
        self._show_loading('Enabling…' if not enabled else 'Disabling…')
        GLib.timeout_add(400, self._load_async)

    def _on_network_clicked(self, _btn, ssid, secured, cur):
        if ssid == cur:
            return
        if secured:
            self._show_password(ssid)
        else:
            self._connect(ssid)

    def _show_password(self, ssid):
        self._clear()
        box = self._box
        box.pack_start(self.header(f'PASSWORD FOR {ssid}'), False, False, 0)

        entry = Gtk.Entry()
        entry.set_visibility(False)
        entry.get_style_context().add_class('pass')
        entry.set_activates_default(True)
        box.pack_start(entry, False, False, 4)

        self._err_lbl = Gtk.Label(label='', xalign=0)
        self._err_lbl.get_style_context().add_class('err')
        box.pack_start(self._err_lbl, False, False, 0)

        row = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=8)
        connect_btn = Gtk.Button(label='Connect')
        connect_btn.get_style_context().add_class('toggle')
        connect_btn.connect('clicked', lambda _b: self._connect(ssid, entry.get_text()))
        pb.use_pointer_cursor(connect_btn)
        cancel_btn = Gtk.Button(label='Cancel')
        cancel_btn.get_style_context().add_class('toggle')
        cancel_btn.connect('clicked', lambda _b: self._reload())
        pb.use_pointer_cursor(cancel_btn)
        row.pack_start(connect_btn, False, False, 0)
        row.pack_start(cancel_btn, False, False, 0)
        box.pack_start(row, False, False, 4)

        box.show_all()
        entry.grab_focus()
        entry.connect('activate', lambda _e: self._connect(ssid, entry.get_text()))

    def _reload(self):
        self._show_loading('Loading networks…')
        GLib.idle_add(self._load_async)

    def _connect(self, ssid, password=None):
        self._show_loading(f'Connecting to {ssid}…')

        def worker():
            if password is not None:
                result = subprocess.run(
                    ['nmcli', 'device', 'wifi', 'connect', ssid, 'password', password],
                    capture_output=True, text=True)
            else:
                saved = ssid in sh('nmcli', '-t', '-f', 'name', 'connection', 'show').splitlines()
                if saved:
                    result = subprocess.run(['nmcli', 'connection', 'up', ssid],
                                             capture_output=True, text=True)
                else:
                    result = subprocess.run(['nmcli', 'device', 'wifi', 'connect', ssid],
                                             capture_output=True, text=True)
            GLib.idle_add(self._on_connect_done, result.returncode == 0,
                          result.stderr.strip(), ssid, password)

        threading.Thread(target=worker, daemon=True).start()

    def _on_connect_done(self, ok, err, ssid, password):
        if ok:
            Gtk.main_quit()
        elif password is not None:
            self._show_password(ssid)
            self._err_lbl.set_text(err[:80] or 'Connection failed')
        else:
            self._reload()
        return False

    def _on_key(self, _, ev):
        if ev.keyval in (Gdk.KEY_Escape, Gdk.KEY_q):
            Gtk.main_quit()


if __name__ == '__main__':
    pb.run(WifiMenu)
