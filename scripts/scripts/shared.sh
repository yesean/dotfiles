#!/usr/bin/env sh

[ "$(uname)" = 'Darwin' ] && is_macos=true || is_macos=false
[ "$(uname)" = 'Linux' ] && is_linux=true || is_linux=false

add() {
  if [ "$is_linux" = 'true' ]; then
    paru -S --noconfirm --needed "$@"
  elif [ "$is_macos" = 'true' ]; then
    brew install "$@"
  fi
}

check() {
  if
    ! command -v "$1" 1>/dev/null 2>&1
  then
    echo "\`${1}\` must be installed."
    exit 1
  fi
}

ghcl() {
  name=$1
  shift
  path=$1
  shift
  git clone -q https://github.com/"$name" "$path" "$@" 2>/dev/null || echo "$name" already installed
}

end() { printf "Finished\n\n"; }
