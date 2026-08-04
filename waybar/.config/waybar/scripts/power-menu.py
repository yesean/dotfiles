#!/usr/bin/env python3
"""Power menu popup — Wayland layer-shell overlay."""
import subprocess

import popup_base as pb
from gi.repository import Gtk

pb.kill_other_popups('power-menu.py')

ITEMS = [
    ('Suspend',   ['systemctl', 'suspend']),
    ('Hibernate', ['systemctl', 'hibernate']),
    ('Shutdown',  ['shutdown', 'now']),
    None,  # separator
    ('Reboot',    ['reboot']),
]


class PowerMenu(pb.OverlayPopup):
    POPUP_W = 200
    EDGE_MARGIN = 20  # power button sits flush against the right edge
    ANCHOR_MATCH = ('⏻',)
    EXTRA_CSS = b"""
    button.pmitem {
      font-family:      "CommitMono", "Symbols Nerd Font", sans-serif;
      background-color: transparent;
      background-image: none;
      border:           none;
      color:            #e0def4;
      font-size:        13px;
      padding:          6px 12px;
      border-radius:    8px;
    }
    button.pmitem:hover { background-color: rgba(87,82,110,0.5); color: #ea9a97; }
    """

    def build_popup(self):
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=2)
        for item in ITEMS:
            if item is None:
                sep = Gtk.Separator()
                sep.get_style_context().add_class('divider')
                box.pack_start(sep, False, False, 0)
                continue
            label, cmd = item
            btn = Gtk.Button(label=label)
            btn.set_relief(Gtk.ReliefStyle.NONE)
            btn.get_style_context().add_class('pmitem')
            btn.get_child().set_halign(Gtk.Align.START)
            btn.connect('clicked', self._on_item, cmd)
            pb.use_pointer_cursor(btn)
            box.pack_start(btn, False, False, 0)
        return box

    def _on_item(self, _btn, cmd):
        subprocess.Popen(cmd)
        Gtk.main_quit()


if __name__ == '__main__':
    pb.run(PowerMenu)
