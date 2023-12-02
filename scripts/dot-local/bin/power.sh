#!/usr/bin/env sh

lock() {
  text=#c0caf5
  ring_color=#c0caf5
  ring_hl_color=#1a1b26
  error=#f7768e
  transparent=#00000000

  i3lock -k \
    --image ~/.lock --fill \
    --time-str="%-I:%M %p" \
    --date-str "%A, %B %d %G" \
    --time-font="SF Pro Display" --time-size=32 \
    --date-font="SF Pro Display" --date-size=16 \
    --pass-media-keys --pass-volume-keys \
    --radius=150 \
    --ring-color="$ring_color" --ringver-color="$ring_color" --ringwrong-color="$error" \
    --inside-color="$transparent" --insidever-color="$transparent" --insidewrong-color="$transparent" \
    --separator-color="$transparent" \
    --line-uses-inside \
    --layout-color="$text" --time-color="$text" --date-color="$text" --greeter-color="$text" \
    --verif-color="$ring_color" --wrong-color="$error" --modif-color="$text" \
    --keyhl-color="$ring_hl_color" --bshl-color="$error" \
    --greeter-text="" \
    --verif-font="SF Pro Display:style=Bold" --verif-text="..." --verif-size=30 \
    --wrong-font="SF Pro Display:style=Bold" --wrong-text="Try again" --wrong-size=30 \
    --noinput-text="No input"
}

logout() {
  ~/.local/bin/workspaces.sh save
  i3-msg exit
}

shutdown() {
  ~/.local/bin/workspaces.sh save
  systemctl poweroff
}

restart() {
  ~/.local/bin/workspaces.sh save
  systemctl reboot
}

if [ "$1" = 'sleep' ]; then
  systemctl suspend
elif [ "$1" = 'lock' ]; then
  lock
elif [ "$1" = 'logout' ]; then
  logout
elif [ "$1" = 'shutdown' ]; then
  shutdown
elif [ "$1" = 'restart' ]; then
  restart
elif [ "$1" = 'prompt' ]; then
  rofi \
    -dpi 150 \
    -theme power \
    -hover-select -me-select-entry '' -me-accept-entry MousePrimary \
    -show power -modes "power:~/.config/rofi/power.sh"
fi
