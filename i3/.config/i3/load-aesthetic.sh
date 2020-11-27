#!/bin/bash

ws="$1"

# start on workspace 1
i3-msg "workspace ${ws}; append_layout ~/.config/i3/workspace-1.json"
(alacritty --hold -t wttr --class wttr -e curl wttr.in/?0 &)
(alacritty --hold -t neofetch --class neofetch -e neofetch &)
(alacritty --hold -t unimatrix --class unimatrix -e ~/terminal-rain.sh &)
(alacritty --hold -t cava --class cava -e cava &)
