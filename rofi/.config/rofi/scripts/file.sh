#!/bin/bash

query=$@
if [[ $query != "" ]]; then
  if [[ $query == *sleep.sh ]] || [[ $query == *restart.sh ]] || [[ $query == *shutdown.sh ]]; then
    bash $query
  fi
  coproc (xdg-open "$query" &>/dev/null)
  exit
else
  fd --type f --follow --exclude "{.git,node_modules,games,venv}" . ~
fi
