#!/bin/bash

for i in {1..10}; do
  i3-resurrect save -w "$i" --swallow=class,instance,title
done

i3-resurrect save -w __i3_scratch

for file in ~/.i3/i3-resurrect/workspace_*_layout.json; do
  node ~/scripts/update-discord-layout.js "$file"
done
