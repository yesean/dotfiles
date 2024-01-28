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

# install neovim plugins
echo "Installing neovim plugins..."
nvim --headless -c 'autocmd User LazyInstall quitall' -c 'Lazy install'
end

# install treesitter plugins
echo "Installing treesitter parsers..."
nvim --headless -c 'TSInstallSync all' -c 'q'
end

# update treesitter plugins
echo "Updating treesitter parsers..."
nvim --headless -c 'TSUpdateSync' -c 'q'
echo
end
