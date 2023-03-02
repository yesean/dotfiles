#!/usr/bin/env sh

case $1 in
  'save')
    i=1
    while [ "$i" -le 10 ]; do
      i3-resurrect save -w "$i" --swallow=class,instance,title
      i=$((i + 1))
    done
    i3-resurrect save -w __i3_scratch
    ;;
  'restore')
    i=1
    while [ "$i" -le 10 ]; do
      i3-resurrect restore -w "$i"
      i=$((i + 1))
    done
    i3-resurrect restore -w __i3_scratch

    if [ "$(rg --hidden --pcre2 '\"class\": \"\^Brave\\\\-browser\$\"' ~/.i3/i3-resurrect/workspace*)" != "" ]; then
      brave
    fi
    ;;
  *)
    echo Usage:
    echo "  workspaces.sh <save|restore>"
    ;;
esac
