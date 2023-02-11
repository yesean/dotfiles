#!/usr/bin/env sh
#
# This script symlinks my dotfiles to their proper system locations. `stow` is
# used to create the symlinks.
#

[ "$DOTFILES_DIR" = "" ] && dots_dir="$HOME/.dotfiles" || dots_dir="$DOTFILES_DIR"
scripts_dir="$dots_dir"/scripts
. "$scripts_dir"/shared.sh

if [ "$is_linux" = "true" ]; then
  set -- alacritty dunst git i3 kitty nvim picom polybar prettier ranger rofi scripts stylua tmux vim zathura zsh
elif [ "$is_macos" = "true" ]; then
  set -- alacritty git kitty nvim prettier scripts skhd stylua tmux vim vscode yabai zsh
else
  echo "This script only works on Linux or macOS."
  exit 1
fi

check stow

cd "$dots_dir" || exit
echo "Creating symlinks..."
for program in "$@"; do
  echo "Symlinking $program"
  stow "$program"
done
end
