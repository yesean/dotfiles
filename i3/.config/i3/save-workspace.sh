#!/bin/bash

ws="$1"

i3-save-tree --workspace "${ws}" > "${HOME}/.config/i3/workspace-${ws}.json"
