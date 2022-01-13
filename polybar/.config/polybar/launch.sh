#!/usr/bin/env bash

## Files and Directories
DIR="$HOME/.config/polybar"
SFILE="$DIR/system"

## Get system variable values for various modules
get_values() {
  INTERFACE=$(ip link | awk '/state UP/ {print $2}' | tr -d :)
}

## Write values to `system` file
set_values() {
  if [[ "$INTERFACE" ]]; then
    sed -i -e "s/network_interface = .*/network_interface = $INTERFACE/g" "$SFILE"
  fi
}

## Launch Polybar with selected style
launch_bar() {
  if [[ ! $(pidof polybar) ]]; then
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
