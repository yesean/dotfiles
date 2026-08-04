#!/usr/bin/env python3
"""System stats popup — CPU, RAM, disk, temps, uptime. Triggered by the single
combined custom/stats bar module (stats-bar.py)."""
import os, re, subprocess
import psutil

import popup_base as pb
from gi.repository import Gtk

pb.kill_other_popups('stats-popup.py')


def sh(*args):
    try:
        return subprocess.check_output(args, text=True).strip()
    except Exception:
        return ''


def hfmt_bytes(n):
    x = n / 1024 / 1024
    return f'{x/1024:.1f} GiB' if x > 1024 else f'{x:.0f} MiB'


def gather():
    cpu_pct = round(psutil.cpu_percent(interval=0.2))
    cpu_cores = psutil.cpu_count() or 1
    try:
        cpu_freq = f'{round(psutil.cpu_freq().current)} MHz'
    except Exception:
        cpu_freq = 'n/a'
    load = '  '.join(f'{x:.2f}' for x in os.getloadavg())

    vm = psutil.virtual_memory()
    sm = psutil.swap_memory()

    root_du = psutil.disk_usage('/')
    root = f'{hfmt_bytes(root_du.used)} / {hfmt_bytes(root_du.total)} ({round(root_du.percent)}% used)'
    try:
        home_du = psutil.disk_usage(os.path.expanduser('~'))
        home = f'{hfmt_bytes(home_du.used)} / {hfmt_bytes(home_du.total)} ({round(home_du.percent)}% used)'
    except Exception:
        home = 'same as /'

    uptime = sh('bash', '-c', "uptime -p | sed 's/^up //'")

    temps = []
    sensors_out = sh('sensors')
    # Only unindented "Label:   +NN.N°C" lines are actual readings; indented
    # lines are continuations (crit=, hyst=, …) and must not be parsed as new ones.
    temp_re = re.compile(r'^(\S[^:]*):\s*\+([0-9]+\.[0-9]+)°C')
    for line in sensors_out.splitlines():
        if not line or line[0].isspace() or 'ALARM' in line:
            continue
        m = temp_re.match(line)
        if m and float(m.group(2)) > 20:
            temps.append((m.group(1).strip(), float(m.group(2))))
        if len(temps) >= 8:
            break
    temps_text = '\n'.join(
        f'{label:<18} {val:>5.1f}°C  ({val*9/5+32:>5.1f}°F)' for label, val in temps)

    net_if = ''
    route = sh('ip', 'route')
    for line in route.splitlines():
        if line.startswith('default'):
            parts = line.split()
            if 'dev' in parts:
                net_if = parts[parts.index('dev') + 1]
            break
    net_info = 'no default interface'
    if net_if and net_if in psutil.net_io_counters(pernic=True):
        io = psutil.net_io_counters(pernic=True)[net_if]
        net_info = (f'{net_if}   down {io.bytes_recv // 1024} KB   '
                    f'up {io.bytes_sent // 1024} KB  (since boot)')

    return dict(
        cpu_pct=cpu_pct, cpu_cores=cpu_cores, cpu_freq=cpu_freq, load=load,
        mem_used=hfmt_bytes(vm.used), mem_total=hfmt_bytes(vm.total),
        mem_avail=hfmt_bytes(vm.available), mem_pct=round(vm.percent),
        swp_used=hfmt_bytes(sm.used), swp_total=hfmt_bytes(sm.total),
        root=root, home=home, uptime=uptime, temps=temps_text, net_info=net_info,
    )


class StatsPopup(pb.OverlayPopup):
    POPUP_W = 460
    # the combined bar module's text always contains a °C reading
    ANCHOR_REGEX = r'°C'
    EXTRA_CSS = b"""
    label.stat   { color: #e0def4; font-size: 12px; }
    label.label  { color: #908caa; font-size: 12px; min-width: 90px; }
    label.mono   { color: #e0def4; font-size: 12px; }
    """

    def build_popup(self):
        d = gather()
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=2)

        box.pack_start(self.header('SYSTEM'), False, False, 0)

        rows = [
            ('CPU', f"{d['cpu_pct']}%   {d['cpu_cores']} cores   {d['cpu_freq']}"),
            ('Load', d['load']),
        ]
        for name, val in rows:
            box.pack_start(self._row(name, val), False, False, 2)

        sep = Gtk.Separator(); sep.get_style_context().add_class('divider')
        box.pack_start(sep, False, False, 0)

        rows = [
            ('RAM', f"{d['mem_used']} / {d['mem_total']}  ({d['mem_pct']}%)"),
            ('Free', d['mem_avail']),
            ('Swap', f"{d['swp_used']} / {d['swp_total']}"),
        ]
        for name, val in rows:
            box.pack_start(self._row(name, val), False, False, 2)

        sep = Gtk.Separator(); sep.get_style_context().add_class('divider')
        box.pack_start(sep, False, False, 0)

        rows = [
            ('/', d['root']),
            ('/home', d['home']),
            ('Network', d['net_info']),
            ('Uptime', d['uptime']),
        ]
        for name, val in rows:
            box.pack_start(self._row(name, val), False, False, 2)

        if d['temps'].strip():
            sep = Gtk.Separator(); sep.get_style_context().add_class('divider')
            box.pack_start(sep, False, False, 0)
            box.pack_start(self.header('TEMPERATURES'), False, False, 0)
            temps_lbl = Gtk.Label(label=d['temps'].strip(), xalign=0)
            temps_lbl.set_line_wrap(False)
            temps_lbl.get_style_context().add_class('mono')
            box.pack_start(temps_lbl, False, False, 2)

        return box

    def _row(self, name, val):
        row = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
        name_lbl = Gtk.Label(label=name, xalign=0)
        name_lbl.get_style_context().add_class('label')
        val_lbl = Gtk.Label(label=val, xalign=0)
        val_lbl.get_style_context().add_class('stat')
        row.pack_start(name_lbl, False, False, 0)
        row.pack_start(val_lbl, False, False, 0)
        return row


if __name__ == '__main__':
    pb.run(StatsPopup)
