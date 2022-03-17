#!/usr/bin/env bash

check() {
  if ! command -v "$1" &>/dev/null; then
    echo "\`${1}\` must be installed. exiting."
    exit 1
  fi
}
start() { echo "Begin syncing ${1}..."; }
end() { echo "Done syncing ${1}"; }

check stow
check nvim

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

start dotfiles
for program in "${programs[@]}"; do
  stow "$program"
done
end dotfiles

# clean and update packer
start packer.nvim
nvim --headless --noplugin -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
end packer.nvim

# update treesitter
start treesitter.nvim
nvim --headless -c 'TSInstallSync maintained' -c 'q'
end treesitter.nvim
