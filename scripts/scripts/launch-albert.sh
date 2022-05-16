#!/usr/bin/env sh

if [ "$(pgrep -c albert)" = "0" ]; then
  echo "Launching albert"
  QT_QPA_PLATFORMTHEME=qt5ct nohup albert &>/dev/null &
else
  echo "Albert is already running."
fi
