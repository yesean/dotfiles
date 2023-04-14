#!/usr/bin/env sh
#
# This script updates my dotfiles.
#
# Creates symlinks for new configs, updates neovim and its plugins.
#

[ "$DOTFILES_DIR" = "" ] && dots_dir="$HOME/.dotfiles" || dots_dir="$DOTFILES_DIR"
scripts_dir="$dots_dir"/scripts
. "$scripts_dir"/shared.sh

"$scripts_dir"/sync.sh

# update neovim plugins
echo "Updating neovim plugins..."
nvim --headless -c 'autocmd User LazySync quitall' -c 'Lazy sync'
end

# install missing treesitter plugins
echo "Installing treesitter parsers..."
nvim --headless -c 'TSInstallSync all' -c 'q'
end

# update treesitter plugins
echo "Updating treesitter parsers..."
nvim --headless -c 'TSUpdateSync' -c 'q'
echo
end
