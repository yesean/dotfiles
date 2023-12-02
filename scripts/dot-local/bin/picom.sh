#!/usr/bin/env sh

if [ "$(pgrep -c picom)" != "0" ]; then
  i3-msg '[class=".*"] border pixel 3'
  pkill -9 picom
else
  i3-msg '[class=".*"] border none'
  picom
fi
