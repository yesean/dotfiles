#!/usr/bin/env sh

if [ "$(pgrep -c picom)" != "0" ]; then
  echo "killing picom"
  pkill -9 picom
else
  echo "starting picom"
  picom -b --experimental-backends &
fi
