#!/usr/bin/env python3
"""Combined CPU/RAM/temperature text for the waybar bar module.
Kept as one module (rather than three) so hovering/clicking it reads as a
single destination — it all opens the same stats-popup.py dropdown."""
import json, re, subprocess
import psutil


def first_temp():
    try:
        out = subprocess.check_output(['sensors'], text=True)
    except Exception:
        return None
    temp_re = re.compile(r'^(\S[^:]*):\s*\+([0-9]+\.[0-9]+)°C')
    for line in out.splitlines():
        if not line or line[0].isspace() or 'ALARM' in line:
            continue
        m = temp_re.match(line)
        if m and float(m.group(2)) > 20:
            return float(m.group(2))
    return None


def main():
    cpu = round(psutil.cpu_percent(interval=0.3))
    mem = round(psutil.virtual_memory().percent)
    disk = round(psutil.disk_usage('/').percent)
    temp = first_temp()
    temp_str = f'{temp:.0f}°C' if temp is not None else 'n/a'

    text = f'{cpu}%    {mem}% 󰌨   {disk}%    {temp_str} '
    tooltip = f'CPU {cpu}%  ·  RAM {mem}%  ·  Disk {disk}%  ·  Temp {temp_str}'
    print(json.dumps({'text': text, 'tooltip': tooltip}))


if __name__ == '__main__':
    main()
