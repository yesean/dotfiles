#!/usr/bin/env python3
"""Clock popup — world times + calendar. Wayland layer-shell overlay."""
import calendar as calmod
import subprocess
from datetime import datetime

import popup_base as pb
from gi.repository import Gtk, GLib

WEEKDAY_LABELS = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']

pb.kill_other_popups('clock-popup.py')

WORLD_TZS = [
    ('New York', 'America/New_York'),
    ('Los Angeles', 'America/Los_Angeles'),
    ('London', 'Europe/London'),
    ('Paris', 'Europe/Paris'),
    ('Dubai', 'Asia/Dubai'),
    ('Tokyo', 'Asia/Tokyo'),
    ('São Paulo', 'America/Sao_Paulo'),
]


def local_tz():
    try:
        tz = subprocess.check_output(
            ['timedatectl', 'show', '--property=Timezone', '--value'], text=True
        ).strip()
        return tz or 'UTC'
    except Exception:
        return 'UTC'


def tz_time(tz):
    try:
        return subprocess.check_output(
            ['env', f'TZ={tz}', 'date', '+%-I:%M %p  %a %b %-d'], text=True
        ).strip()
    except Exception:
        return '--:--'




class ClockPopup(pb.OverlayPopup):
    POPUP_W = 460
    EDGE_MARGIN = 24  # clock sits closest to the right edge of any module
    ANCHOR_REGEX = r'\d{1,2}:\d{2}:\d{2}\s*(AM|PM)'
    EXTRA_CSS = b"""
    label.city        { color: #e0def4; font-size: 13px; }
    label.city-local  { color: #ea9a97; font-size: 13px; font-weight: 700; }
    label.time        { color: #908caa; font-size: 13px; }
    label.footer       { color: #6e6a86; font-size: 11px; }
    label.cal-month    { color: #e0def4; font-size: 13px; font-weight: 700; }
    label.cal-weekday  { color: #6e6a86; font-size: 11px; font-weight: 700; }
    label.cal-day      { color: #e0def4; font-size: 13px; }
    label.cal-day-other-month { color: #393552; font-size: 13px; }
    label.cal-today {
      color:            #232136;
      background-color: #ea9a97;
      font-weight:       700;
      font-size:          13px;
      border-radius:     50%;
      min-width:          26px;
      min-height:         26px;
    }
    """

    def build_popup(self):
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)

        box.pack_start(self.header('WORLD CLOCKS'), False, False, 0)

        tz = local_tz()
        local_label = tz.rsplit('/', 1)[-1].replace('_', ' ')
        box.pack_start(self._city_row(f'{local_label} (local)', tz_time(tz), local=True), False, False, 2)
        for name, tzname in WORLD_TZS:
            if tzname == tz:
                continue
            box.pack_start(self._city_row(name, tz_time(tzname)), False, False, 2)

        sep = Gtk.Separator()
        sep.get_style_context().add_class('divider')
        box.pack_start(sep, False, False, 0)

        box.pack_start(self.header('CALENDAR'), False, False, 0)

        today = datetime.now()

        today_lbl = Gtk.Label(label=today.strftime('%A, %B %-d, %Y'), xalign=0)
        today_lbl.get_style_context().add_class('city-local')
        box.pack_start(today_lbl, False, False, 8)

        box.pack_start(self._build_calendar_grid(today), False, False, 0)

        doy = today.strftime('%j')
        woy = today.strftime('%V')
        self._footer = Gtk.Label(label='', xalign=0)
        self._footer.get_style_context().add_class('footer')
        self._doy_woy = f'Day {doy} of year  ·  Week {woy}'
        self._update_footer()
        box.pack_start(self._footer, False, False, 12)

        GLib.timeout_add(1000, self._tick)

        return box

    def _update_footer(self):
        epoch = int(datetime.now().timestamp())
        self._footer.set_text(f'{self._doy_woy}  ·  Unix {epoch}')

    def _tick(self):
        self._update_footer()
        return True

    def _build_calendar_grid(self, today):
        cal = calmod.Calendar(firstweekday=6)  # Sunday-first, matches WEEKDAY_LABELS
        weeks = cal.monthdayscalendar(today.year, today.month)

        grid = Gtk.Grid()
        grid.set_column_homogeneous(True)
        grid.set_row_spacing(10)
        grid.set_column_spacing(4)

        for col, wd in enumerate(WEEKDAY_LABELS):
            lbl = Gtk.Label(label=wd)
            lbl.get_style_context().add_class('cal-weekday')
            lbl.set_halign(Gtk.Align.CENTER)
            grid.attach(lbl, col, 0, 1, 1)

        for row_idx, week in enumerate(weeks, start=1):
            for col, day in enumerate(week):
                if day == 0:
                    continue
                lbl = Gtk.Label(label=str(day))
                lbl.set_halign(Gtk.Align.CENTER)
                lbl.set_valign(Gtk.Align.CENTER)
                lbl.get_style_context().add_class(
                    'cal-today' if day == today.day else 'cal-day')
                grid.attach(lbl, col, row_idx, 1, 1)

        return grid

    def _city_row(self, name, time_str, local=False):
        row = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
        name_lbl = Gtk.Label(label=name, xalign=0)
        name_lbl.get_style_context().add_class('city-local' if local else 'city')
        time_lbl = Gtk.Label(label=time_str, xalign=1)
        time_lbl.get_style_context().add_class('time')
        row.pack_start(name_lbl, True, True, 0)
        row.pack_start(time_lbl, False, False, 0)
        return row


if __name__ == '__main__':
    pb.run(ClockPopup)
