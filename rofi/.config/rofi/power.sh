#!/usr/bin/env bash

uptime="Uptime: $(uptime -p | cut -c 4-)"
sleep='󰒲  Sleep'
lock='󰌾  Lock'
logout='󰗽  Logout'
shutdown='󰐥  Shutdown'
restart='󰜉  Restart'

if [ "$1" != "" ]; then
  case $1 in
    "$sleep")
      coproc "$HOME/.local/bin/power.sh" sleep
      ;;
    "$lock")
      coproc "$HOME/.local/bin/power.sh" lock
      ;;
    "$logout")
      coproc "$HOME/.local/bin/power.sh" logout
      ;;
    "$shutdown")
      "$HOME/.local/bin/power.sh" shutdown
      ;;
    "$restart")
      "$HOME/.local/bin/power.sh" restart
      ;;
  esac
  exit 0
fi

printf "\0message\x1f%s\n" "$uptime"
printf "%s\n" "$sleep"
printf "%s\n" "$lock"
printf "%s\n" "$logout"
printf "%s\n" "$shutdown"
printf "%s" "$restart"
