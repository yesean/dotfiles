#!/usr/bin/env bash

check() {
  if ! command -v "$1" &>/dev/null; then
    echo "\\\`${1}\\\` must be installed. exiting."
    exit 1
  fi
}
start() { echo "Begin ${1}..."; }
end() { echo "Done ${1}"; }

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

start "syncing dotfiles"
for program in "${programs[@]}"; do
  stow "$program"
done
end "syncing dotfiles"

# clean and update packer
start "updating packer.nvim"
nvim --headless --noplugin -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
end "updating packer.nvim"

# update treesitter
start "updating treesitter.nvim"
nvim --headless -c 'TSInstallSync maintained' -c 'q'
echo
end "updating treesitter.nvim"
