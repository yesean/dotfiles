#!/bin/bash

[[ $(uname) = 'Darwin' ]] && is_macos=true || is_macos=false
[[ $(uname) = 'Linux' ]] && is_linux=true || is_linux=false

dotfiles_dir="$HOME/.dotfiles"
config_dir="$HOME/.config"

cd "$dotfiles_dir" || exit

# remove config dir symlink if it exists
if [[ -L $config_dir ]]; then
  echo "Removing symlink at $config_dir"
  rm "$config_dir"
fi

# create config directory if it doesn't exist
if [[ ! -d $config_dir ]]; then
  echo "Creating configuration directory at ~/.config/"
  mkdir "$config_dir"
fi

if [[ "$is_linux" == "true" ]]; then
  echo 'Linux machine detected!'
  echo 'Installing for linux:'
  programs=(alacritty git i3 nvim picom polybar prettier ranger rofi tmux vim vscode zathura zsh)
elif [[ "$is_macos" == "true" ]]; then
  echo 'macOS machine detected!'
  echo 'Installing for macos:'
  programs=(alacritty git nvim prettier skhd tmux vim vscode yabai zsh)
else
  echo "Unknown machine detected."
  exit 1
fi

for program in "${programs[@]}"; do
  echo "Installing $program configuration"
  stow -v 1 "$program"
done
