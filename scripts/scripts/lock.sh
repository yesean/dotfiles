#!/usr/bin/env sh

i3lock -k \
  --image ~/pictures/wallpapers/glaciers-background.png \
  --time-str="%-I:%M %p" \
  --date-str "%A, %B %d %G" \
  --time-font="SF Pro Display" --time-size=32 \
  --date-font="SF Pro Display" --date-size=16 \
  --pass-media-keys --pass-volume-keys \
  --radius=150 \
  --inside-color=00000000 --ring-color=ccd0da \
  --insidever-color=00000000 --ringver-color=dc8a78 \
  --insidewrong-color=00000000 --ringwrong-color=e64553 \
  --separator-color=9ca0b0 --line-color=00000000 \
  --keyhl-color=4c4f69 \
  --greeter-font="SF Pro Display" --greeter-text="what's da password fam" \
  --verif-font="SF Pro Display Bold" --verif-text="checking..." --verif-size=20 \
  --wrong-font="SF Pro Display Bold" --wrong-text="r u dumb?" --wrong-size=20
