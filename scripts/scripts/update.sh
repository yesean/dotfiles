#!/usr/bin/env sh
#
# This script updates my dotfiles.
#
# Creates symlinks for new configs, updates neovim and its plugins.
#

[ "$DOTFILES_DIR" = "" ] && dots_dir="$HOME/.dotfiles" || dots_dir="$DOTFILES_DIR"
scripts_dir="$dots_dir"/scripts/scripts
. "$scripts_dir"/shared.sh

"$scripts_dir"/sync.sh

echo "Building neovim..."
"$scripts_dir"/build-neovim.sh
end

# clean and update packer
echo "Updating neovim plugins..."
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
end

# update treesitter
echo "Installing treesitter parsers..."
nvim --headless -c 'TSInstallSync all' -c 'q'
end

echo "Updating treesitter parsers..."
nvim --headless -c 'TSUpdateSync' -c 'q'
echo
end
