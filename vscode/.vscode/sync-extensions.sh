#!/bin/bash

rm -rf ~/.vscode/extensions

# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")

<"${SCRIPTPATH}/extensions" xargs -n1 code --install-extension
