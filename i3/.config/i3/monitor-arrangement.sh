#!/bin/bash

xrandr --output DP-0.1.8 --rotate left --auto --left-of DP-0.8
xrandr --output DP-0.8 --auto --pos 1440x550

# reset background
~/.config/i3/.fehbg &

