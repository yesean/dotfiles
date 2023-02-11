#!/usr/bin/env sh
#
# This script pulls changes and rebuilds neovim from source.
#

neovim_dir="$HOME/projects/neovim"

cd "$neovim_dir" || exit
git pull
make CMAKE_BUILD_TYPE=RelWithDebInfo || sudo make distclean && make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install >/dev/null
