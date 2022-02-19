#!/usr/bin/env bash

# append saved layout of workspace 10
i3-resurrect restore -w 1
i3-resurrect restore -w 2
i3-resurrect restore -w 3
i3-resurrect restore -w 4
i3-resurrect restore -w 5
i3-resurrect restore -w 6
i3-resurrect restore -w 7
i3-resurrect restore -w 8
i3-resurrect restore -w 9
i3-resurrect restore -w 10
i3-resurrect restore -w __i3_scratch

if [[ $(rg --hidden --pcre2 '\"class\": \"\^Brave\\\\-browser\$\"' ~/.i3/i3-resurrect/workspace*) != "" ]]; then
  brave
fi
