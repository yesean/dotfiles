#!/usr/bin/env python3
"""Shared base for waybar Wayland layer-shell popups — fullscreen transparent
overlay that hosts a positioned content box and closes on outside click."""
import os, re, subprocess, json, signal, cairo

import gi
gi.require_version('Gtk', '3.0')
gi.require_version('GtkLayerShell', '0.1')
from gi.repository import Gtk, Gdk, GLib, GtkLayerShell

BAR_H = 54   # margin-top(8) + height(46)
GAP   = 4

_POPUP_SCRIPTS = [
    'volume-control.py', 'spotify-popup.py',
    'clock-popup.py', 'stats-popup.py', 'wifi-menu.py',
]


def kill_other_popups(this_script):
    my = os.getpid()
    for pat in _POPUP_SCRIPTS:
        if pat == this_script:
            continue
        try:
            r = subprocess.run(['pgrep', '-f', pat], capture_output=True, text=True)
            for s in r.stdout.split():
                try:
                    pid = int(s)
                    if pid == my:
                        continue
                    try:
                        exe = os.readlink(f'/proc/{pid}/exe')
                        if 'python' not in exe:
                            continue
                    except Exception:
                        continue
                    os.kill(pid, signal.SIGTERM)
                except Exception:
                    pass
        except Exception:
            pass
    subprocess.run(['pkill', '-x', 'rofi'], capture_output=True)


def cursor_x():
    try:
        raw = subprocess.check_output(['hyprctl', 'cursorpos'], text=True).strip()
        return int(raw.split(',')[0].strip())
    except Exception:
        return 3000


def logical_width():
    try:
        out = subprocess.check_output(['hyprctl', 'monitors', '-j'], text=True)
        m = json.loads(out)[0]
        return round(m['width'] / m.get('scale', 1.0))
    except Exception:
        return 3850


def find_module_anchor(match_substrings=(), match_regex=None):
    """Locate the waybar module label matching the given signature via AT-SPI
    and return (center_x, bottom_y) in logical px, or None if not found."""
    try:
        gi.require_version('Atspi', '2.0')
        from gi.repository import Atspi
    except Exception:
        return None

    try:
        desktop = Atspi.get_desktop(0)
        waybar = None
        for i in range(desktop.get_child_count()):
            app = desktop.get_child_at_index(i)
            try:
                if app.get_name() == 'waybar':
                    waybar = app
                    break
            except Exception:
                continue
        if waybar is None:
            return None

        found = []

        def walk(obj, depth=0):
            if depth > 10 or found:
                return
            try:
                role = obj.get_role_name()
            except Exception:
                role = ''
            if role == 'label':
                try:
                    name = obj.get_name() or ''
                except Exception:
                    name = ''
                matched = bool(match_regex and re.search(match_regex, name))
                if not matched:
                    matched = any(s in name for s in match_substrings)
                if matched:
                    try:
                        ext = obj.get_extents(Atspi.CoordType.SCREEN)
                        if ext.width > 0 and ext.x > -1000000:
                            found.append((ext.x + ext.width / 2, ext.y + ext.height))
                    except Exception:
                        pass
                    return
            try:
                nchild = obj.get_child_count()
            except Exception:
                nchild = 0
            for i in range(nchild):
                try:
                    walk(obj.get_child_at_index(i), depth + 1)
                except Exception:
                    pass

        walk(waybar)
        return found[0] if found else None
    except Exception:
        return None


BASE_CSS = b"""
* { font-family: "CommitMono", "Symbols Nerd Font", sans-serif; font-size: 13px; }
window { background-color: transparent; }
box#popup {
  background-color: rgba(42,39,63,0.96);
  border:           1px solid rgba(234,154,151,0.4);
  border-radius:    12px;
  padding:          16px 18px;
}
label.header {
  color:       #f6c177;
  font-weight: 700;
  font-size:   11px;
}
separator.section-line {
  background-color: #393552;
  min-height: 1px;
  margin: 4px 0 12px 0;
}
separator.divider {
  background-color: #393552;
  min-height: 1px;
  margin: 20px 0;
}
"""


ARROW_W = 18
ARROW_H = 9
ARROW_MARGIN = 14  # keep arrow tip clear of the popup's rounded corners

_POPUP_BG    = (42 / 255, 39 / 255, 63 / 255, 0.96)
_POPUP_BORD  = (234 / 255, 154 / 255, 151 / 255, 0.4)


class _ArrowWidget(Gtk.DrawingArea):
    def __init__(self):
        super().__init__()
        self.set_size_request(ARROW_W, ARROW_H + 1)
        self.connect('draw', self._draw)

    def _draw(self, _widget, cr):
        cr.move_to(0, ARROW_H)
        cr.line_to(ARROW_W / 2, 0)
        cr.line_to(ARROW_W, ARROW_H)
        cr.close_path()
        cr.set_source_rgba(*_POPUP_BG)
        cr.fill_preserve()
        cr.set_source_rgba(*_POPUP_BORD)
        cr.set_line_width(1)
        cr.stroke()
        return False


class OverlayPopup(Gtk.Window):
    """Subclasses implement build_popup() -> Gtk.Widget and may set EXTRA_CSS / POPUP_W.

    Positioning anchors to the triggering waybar module (found via AT-SPI, matched
    by ANCHOR_MATCH / ANCHOR_REGEX) rather than the click point, so the popup always
    appears in the same place under that module. Falls back to cursor position if
    the module can't be located. A small arrow is drawn pointing at the module."""

    EXTRA_CSS = b""
    POPUP_W = 400
    ANCHOR_MATCH = ()
    ANCHOR_REGEX = None
    EDGE_MARGIN = 10  # min gap kept from either screen edge

    def __init__(self):
        super().__init__(type=Gtk.WindowType.TOPLEVEL)
        self.set_decorated(False)
        self.set_resizable(False)
        self.set_app_paintable(True)

        screen = self.get_screen()
        visual = screen.get_rgba_visual()
        if visual:
            self.set_visual(visual)

        prov = Gtk.CssProvider()
        prov.load_from_data(BASE_CSS + self.EXTRA_CSS)
        Gtk.StyleContext.add_provider_for_screen(
            screen, prov, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)

        GtkLayerShell.init_for_window(self)
        GtkLayerShell.set_layer(self, GtkLayerShell.Layer.OVERLAY)
        GtkLayerShell.set_anchor(self, GtkLayerShell.Edge.TOP,    True)
        GtkLayerShell.set_anchor(self, GtkLayerShell.Edge.BOTTOM, True)
        GtkLayerShell.set_anchor(self, GtkLayerShell.Edge.LEFT,   True)
        GtkLayerShell.set_anchor(self, GtkLayerShell.Edge.RIGHT,  True)
        GtkLayerShell.set_exclusive_zone(self, -1)
        GtkLayerShell.set_keyboard_mode(self, GtkLayerShell.KeyboardMode.ON_DEMAND)

        self.add_events(Gdk.EventMask.BUTTON_PRESS_MASK)
        self.connect('map', self._on_map)

        anchor = None
        if self.ANCHOR_MATCH or self.ANCHOR_REGEX:
            anchor = find_module_anchor(self.ANCHOR_MATCH, self.ANCHOR_REGEX)

        sw = logical_width()
        # Vertical position is always just below the bar itself — the module
        # label's own bottom edge sits inside the bar's padding, not at its
        # bottom, so it can't be used for py without overlapping the bar.
        py = BAR_H + GAP
        anchor_cx = anchor[0] if anchor else cursor_x()

        # Center under the module; if that overflows the right edge, shift left.
        m = self.EDGE_MARGIN
        px = max(m, min(int(anchor_cx) - self.POPUP_W // 2, sw - self.POPUP_W - m))

        popup = self.build_popup()
        popup.set_name('popup')
        popup.set_size_request(self.POPUP_W, -1)
        self._popup = popup

        fixed = Gtk.Fixed()

        arrow_x = max(px + ARROW_MARGIN,
                      min(int(anchor_cx) - ARROW_W // 2, px + self.POPUP_W - ARROW_MARGIN - ARROW_W))
        arrow = _ArrowWidget()
        fixed.put(arrow, arrow_x, py - ARROW_H + 1)

        fixed.put(popup, px, py)
        self.add(fixed)

        self.connect('button-press-event', self._on_bg_click)
        self.connect('key-press-event', self._on_key)

    def build_popup(self):
        raise NotImplementedError

    def _on_map(self, _):
        gdk_win = self.get_window()
        if gdk_win:
            region = cairo.Region(cairo.RectangleInt(0, 0, 10000, 10000))
            gdk_win.input_shape_combine_region(region, 0, 0)

    def _on_bg_click(self, widget, event):
        alloc = self._popup.get_allocation()
        if not (alloc.x <= event.x <= alloc.x + alloc.width and
                alloc.y <= event.y <= alloc.y + alloc.height):
            Gtk.main_quit()
        return False

    def _on_key(self, _, ev):
        if ev.keyval in (Gdk.KEY_Escape, Gdk.KEY_q):
            Gtk.main_quit()

    def header(self, text):
        b = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=4)
        lbl = Gtk.Label(label=text, xalign=0)
        lbl.get_style_context().add_class('header')
        b.pack_start(lbl, False, False, 0)
        sep = Gtk.Separator()
        sep.get_style_context().add_class('section-line')
        b.pack_start(sep, False, False, 0)
        return b


def use_pointer_cursor(widget, drag_cursor=None):
    """Show a hand/pointer cursor while hovering an interactive widget.
    GTK CSS has no `cursor` property, so this has to be done via GDK directly.

    If drag_cursor is given (e.g. 'grabbing'), the cursor switches to it while
    a mouse button is held down over the widget — useful for sliders, so the
    user gets visual feedback that they're actively dragging, not just hovering."""
    events = Gdk.EventMask.ENTER_NOTIFY_MASK | Gdk.EventMask.LEAVE_NOTIFY_MASK
    if drag_cursor:
        events |= Gdk.EventMask.BUTTON_PRESS_MASK | Gdk.EventMask.BUTTON_RELEASE_MASK
    widget.add_events(events)

    def set_cursor(w, name):
        gdk_win = w.get_window()
        if gdk_win:
            cursor = Gdk.Cursor.new_from_name(Gdk.Display.get_default(), name) if name else None
            gdk_win.set_cursor(cursor)

    def on_enter(w, _ev):
        set_cursor(w, 'pointer')

    def on_leave(w, _ev):
        set_cursor(w, None)

    if drag_cursor:
        widget.connect('button-press-event', lambda w, _ev: set_cursor(w, drag_cursor))
        widget.connect('button-release-event', lambda w, _ev: set_cursor(w, 'pointer'))

    widget.connect('enter-notify-event', on_enter)
    widget.connect('leave-notify-event', on_leave)


def run(window_cls):
    w = window_cls()
    w.connect('destroy', Gtk.main_quit)
    w.show_all()
    Gtk.main()
