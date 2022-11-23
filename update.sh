#!/usr/bin/env sh
#
# This script updates my dotfiles.
#
# Creates symlinks for new configs, updates neovim and its plugins.
#

check() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "\`${1}\` must be installed, exiting."
    exit 1
  fi
}
end() { printf "Finished\n\n"; }

[ "$DOTFILES_DIR" = "" ] && dots_dir="$HOME/.dotfiles" || dots_dir="$DOTFILES_DIR"

"$dots_dir"/sync.sh

~/scripts/build-neovim.sh

check nvim

# clean and update packer
echo "Updating neovim plugins..."
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
end

# update treesitter
echo "Updating treesitter parsers..."
nvim --headless -c 'TSInstallSync all' -c 'q'
nvim --headless -c 'TSUpdateSync' -c 'q'
echo
end
