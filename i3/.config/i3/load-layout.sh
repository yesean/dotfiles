#!/bin/zsh

killall spotify Alacritty gnome-calendar mailspring todoist Discord caprine &

# append saved layout of workspace 10
i3-msg "workspace 10; append_layout ~/.config/i3/utilities.json"
(spotify &)
(alacritty -t cava --class cava -e cava &)
(alacritty -t gtop --class gtop -e gtop &)

# append saved layout of workspace 9
i3-msg "workspace 9; append_layout ~/.config/i3/productivity.json"
(mailspring &)
(gnome-calendar &)
(todoist &)

# append saved layout of workspace 8
i3-msg "workspace 8; append_layout ~/.config/i3/social.json"
(caprine &)
(discord &)

