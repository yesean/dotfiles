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
    --insidever-color=00000000 --ringver-color=dc8a78 \
    --insidewrong-color=00000000 --ringwrong-color=e64553 \
    --separator-color=9ca0b0 --line-color=00000000 \
    --keyhl-color=4c4f69 \
    --greeter-font="SF Pro Display" --greeter-text="what's da password fam" \
    --verif-font="SF Pro Display Bold" --verif-text="checking..." --verif-size=20 \
    --wrong-font="SF Pro Display Bold" --wrong-text="r u dumb?" --wrong-size=20
}

logout() {
  ~/scripts/save-workspaces.sh
  i3-msg exit
}

shutdown() {
  ~/scripts/save-workspaces.sh
  systemctl poweroff
}

restart() {
  ~/scripts/save-workspaces.sh
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
  action=$(printf 'Lock;Logout;Sleep;Shutdown;Restart\n' | rofi -theme power -dmenu -i -sep ';')
  case $action in
    'Lock')
      "$0" lock
      ;;
    'Logout')
      "$0" logout
      ;;
    'Sleep')
      "$0" sleep
      ;;
    'Shutdown')
      "$0" shutdown
      ;;
    'Restart')
      "$0" restart
      ;;
    *) exit 1 ;;
  esac
fi
