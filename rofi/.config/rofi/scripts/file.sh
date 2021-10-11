#!/usr/bin/env bash

query=$*
if [[ $query != "" ]]; then
  if [[ $query == *sleep.sh ]] || [[ $query == *restart.sh ]] || [[ $query == *shutdown.sh ]]; then
    eval "$query"
    exit
  else
    coproc xdg-open "$query" &>/dev/null
    exit
  fi
else
  fd . \
    --type f \
    --follow \
    --exclude Cache \
    --exclude Default \
    --exclude modules \
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
    --exec echo -ne "{}\x0icon\x1ftext-x-generic\n"
fi
