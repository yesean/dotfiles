#!/usr/bin/env sh

display_adapter=$(xrandr | grep " connected " | cut -f 1 -d " ")

if [ "$1" = 'full' ]; then
  xrandr --output "$display_adapter" --mode 3440x1440 --rate 100
  i3-msg restart
elif [ "$1" = 'half' ]; then
  xrandr --output "$display_adapter" --mode 1720x1440 --rate 100
  i3-msg restart
else
  echo 'set-resolution <full|half>'
fi
