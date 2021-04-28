#!/bin/bash

query=$@
if [[ $query != "" ]]; then
  coproc (xdg-open "$query" &> /dev/null)
  exit
else
  fd --follow --exclude "{.git,node_modules,games}" . ~
fi
