#!/bin/bash

# delete existing extensions
rm -rf ~/.vscode/extensions/

# install extensions
xargs -tn 1 code --install-extension < ~/.dotfiles/vscode/.config/Code/extensions.txt
