#!/usr/bin/env sh

winid=$(xdotool getactivewindow 2>/dev/null)
if [ "$winid" = "" ]; then
  echo arch && exit 0
fi

winclass=$(xprop -id "$winid" | grep "WM_CLASS(STRING)" | grep -v "grep" | cut -d "=" -f 2 | cut -d "," -f 2 | tr -d '"' | xargs)
echo "$winclass"
