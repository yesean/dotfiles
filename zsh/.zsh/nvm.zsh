lazy_load_nvm() {
  unset -f node nvm npm

  if [[ "$is_linux" == true ]]; then
    source /usr/share/nvm/init-nvm.sh
  elif [[ "$is_macos" == true ]]; then
    source "$(brew --prefix)/opt/nvm/nvm.sh"
  fi
}

node() {
  lazy_load_nvm
  node $@
}

nvm() {
  lazy_load_nvm
  nvm $@
}

npm() {
  lazy_load_nvm
  npm $@
}
