#!/bin/bash

if [ -z "$1" ]
then
  ws=1
else
  ws=$1
fi

# start on workspace 1
i3-msg "workspace ${ws}; append_layout ~/.config/i3/aesthetic.json"
(alacritty --hold -t wttr --class wttr -e curl wttr.in/?0 &)
(alacritty --hold -t neofetch --class neofetch -e neofetch &)
(alacritty --hold -t unimatrix --class unimatrix -e ~/.local/bin/terminal-rain.sh &)
(alacritty --hold -t cava --class cava -e cava &)
