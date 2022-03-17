#!/usr/bin/env bash

start() { echo "Begin ${1}..."; }
end() { echo "Done ${1}"; }

if ! command -v stow &>/dev/null; then
  echo "GNU Stow must be installed in order to run the install script"
  exit 1
fi

[[ $(uname) = 'Darwin' ]] && is_macos=true || is_macos=false
[[ $(uname) = 'Linux' ]] && is_linux=true || is_linux=false
if [[ "$is_linux" == "true" ]]; then
  echo 'Linux detected!'
  programs=(alacritty dunst git i3 nvim picom polybar prettier ranger scripts stylua tmux vim zathura zsh)
elif [[ "$is_macos" == "true" ]]; then
  echo 'macOS detected!'
  programs=(alacritty git nvim prettier skhd stylua tmux vim vscode yabai zsh)
else
  echo "Unknown machine detected."
  exit 1
fi

start "syncing dotfiles"
for program in "${programs[@]}"; do
  stow "$program"
done
end "syncing dotfiles"

# clean and update packer
start "updating packer.nvim"
nvim --headless --noplugin -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
end "updating packer.nvim"
