#!/usr/bin/env sh

if [ "$1" = 'full' ]; then
  xrandr --output DP-0 --mode 3440x1440 --rate 100
  i3-msg restart
elif [ "$1" = 'half' ]; then
  xrandr --output DP-0 --mode 1720x1440 --rate 100
  i3-msg restart
else
  echo 'set-resolution <full|half>'
fi
