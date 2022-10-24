#!/usr/bin/env sh

winid=$(xdotool getactivewindow)
winclass=$(xprop -id "$winid" | grep "WM_CLASS(STRING)" | cut -d "=" -f 2 | cut -d "," -f 2 | tr -d '"')
echo "$winclass"
