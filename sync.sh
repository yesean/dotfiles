#!/usr/bin/env bash

check() {
  if ! command -v "$1" &>/dev/null; then
    echo "\`${1}\` must be installed. exiting."
    exit 1
  fi
}
begin() { echo "Begin $*..."; }
end() { echo "Done $*"; }

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

begin stowing dotfiles
for program in "${programs[@]}"; do
  stow "$program"
done
end stowing dotfiles

# clean and update packer
begin updating neovim plugins
nvim --headless --noplugin -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
end updating neovim plugins

# update treesitter
begin updating treesitter plugins
nvim --headless -c 'TSInstallSync all' -c 'q'
end updating treesitter plugins
