#!/bin/bash

query=$@
if [[ $query != "" ]]; then
  if [[ $query == *sleep.sh ]] || [[ $query == *restart.sh ]] || [[ $query == *shutdown.sh ]]; then
    bash $query
  fi
  coproc (xdg-open "$query" &>/dev/null)
  exit
else
  fd --type f --follow \
    --search-path ~/Downloads/ \
    --search-path ~/documents/ \
    --search-path ~/projects/ \
    --search-path ~/pictures/ \
    --search-path ~/gd-personal/ \
    --search-path ~/gd-ucsd/ \
    --search-path ~/pictures/ \
    --search-path ~/scripts/ \
    --search-path ~/.dotfiles/ \
    --search-path ~/.config/ \
    --exclude Cache \
    --exclude Default \
    --exclude modules \
    --exec echo -en "{}\x0icon\x1ftext-x-generic\n"
  .
fi
