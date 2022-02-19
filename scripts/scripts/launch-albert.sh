#!/usr/bin/env sh

if [ "$(pgrep -c albert)" = "0" ]; then
  echo "Launching albert"
  QT_QPA_PLATFORMTHEME=gtk2 albert &
else
  echo "Albert is already running."
fi
