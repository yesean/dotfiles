#!/usr/bin/env sh

lock() {
  i3lock -k \
    --image ~/pictures/wallpapers/glaciers-background.png \
    --time-str="%-I:%M %p" \
    --date-str "%A, %B %d %G" \
    --time-font="SF Pro Display" --time-size=32 \
    --date-font="SF Pro Display" --date-size=16 \
    --pass-media-keys --pass-volume-keys \
    --radius=150 \
    --inside-color=00000000 --ring-color=ccd0da \
    --insidever-color=00000000 --ringver-color=4c4f69 \
    --insidewrong-color=00000000 --ringwrong-color=e64553 \
    --separator-color=9ca0b0 --line-color=00000000 \
    --keyhl-color=4c4f69 \
    --greeter-text="" \
    --verif-font="SF Pro Display:style=Bold" --verif-text="Checking..." --verif-size=30 \
    --wrong-font="SF Pro Display:style=Bold" --wrong-text="Incorrect" --wrong-size=30
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
    -theme power \
    -hover-select -me-select-entry '' -me-accept-entry MousePrimary \
    -show power -modes "power:~/.config/rofi/power.sh"
fi
