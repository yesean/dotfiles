#!/bin/bash

# delete existing extensions
# rm -rf ~/.vscode/extensions/

# install extensions
xargs -pn 1 code --force --install-extension < ~/.dotfiles/vscode/.config/Code/extensions.txt
