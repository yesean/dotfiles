#!/usr/bin/env bash

# files and directories
DIR="$HOME/.config/polybar"
SFILE="$DIR/system"

# get system variable values for various modules
get_values() {
  INTERFACE=$(ip link | awk '/state UP/ {print $2}' | tr -d :)
}

# write values to `system` file
set_values() {
  if [ "$INTERFACE" ]; then
    echo "Setting INTERFACE to $INTERFACE"
    sed -i -e "s/network_interface =.*/network_interface = $INTERFACE/g" "$SFILE"
  fi
}

# launch polybar with selected style
launch_bar() {
  get_values
  set_values

  if [ ! "$(pidof polybar)" ]; then
    polybar -q main -c "$DIR"/config &
  else
    polybar-msg cmd restart
  fi

  if type "xrandr" >/dev/null; then
    echo "Lanching polybar for each screen"
    xrandr --listactivemonitors | grep -oP '(HDMI\-\d+$|eDP\-\d+$)' | xargs -P1 -I{} bash -c "MONITOR={} polybar -q -r p00 &"
  fi
}

launch_bar
