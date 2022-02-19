#!/usr/bin/env sh

round() {
  printf "%.0f" "$1"
}

cpu_usage=$(round "$(top -bn 1 | grep -oP "(\d+[.]\d+)(?= us,)")")
cpu_temp=$(round "$(sensors | grep Tctl | tr -s " " | cut -d " " -f 2 | tr -d "+" | tr -cd "[:digit:].")")

echo "$cpu_usage% $cpu_temp°C"
