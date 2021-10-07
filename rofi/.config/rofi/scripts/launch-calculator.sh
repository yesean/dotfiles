#!/bin/bash

rofi -show calc -modi calc -no-show-match -no-sort -theme ~/.dotfiles/rofi/.config/rofi/themes/calculator.rasi -calc-command "echo -en '{result}' | xclip -selection clipboard"
