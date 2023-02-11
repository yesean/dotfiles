#!/usr/bin/env sh

if [ "$(pgrep -c picom)" != "0" ]; then
  pkill -9 picom
  i3-msg '[class=".*"] border pixel 3'
else
  picom -b --experimental-backends &
  i3-msg '[class=".*"] border none'
fi
