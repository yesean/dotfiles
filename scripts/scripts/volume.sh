#!/usr/bin/env bash

get_volume() {
  pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '[0-9]+(?=%)' | head -n 1
}

is_mute() {
  pactl get-sink-mute @DEFAULT_SINK@ | grep -oP '(?<=Mute: ).*'
}

if [[ $1 == 'up' ]]; then
  pactl set-sink-volume @DEFAULT_SINK@ +5%
  volnoti-show "$(get_volume)"
elif [[ $1 == 'down' ]]; then
  pactl set-sink-volume @DEFAULT_SINK@ -5%
  volnoti-show "$(get_volume)"
elif [[ $1 == 'status' ]]; then
  get_volume
elif [[ $1 == 'set' ]]; then
  pactl set-sink-volume @DEFAULT_SINK@ "$2"
elif [[ $1 == 'mute' ]]; then
  pactl set-sink-mute @DEFAULT_SINK@ toggle
  if [[ $(is_mute) == 'yes' ]]; then
    volnoti-show -m
  else
    volnoti-show "$(get_volume)"
  fi
elif [[ $1 == 'mute-mic' ]]; then
  pactl set-source-mute @DEFAULT_SOURCE@ toggle
fi
