#!/usr/bin/env sh
#
# This script pulls changes and rebuilds neovim from source.
#

cd ~/neovim || exit
git pull
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
