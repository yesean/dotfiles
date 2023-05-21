lazy_load_nvm() {
  unset -f nvm node npm

  if [[ "$is_linux" == true ]]; then
    source /usr/share/nvm/init-nvm.sh
  elif [[ "$is_macos" == true ]]; then
    source "$(brew --prefix)/opt/nvm/nvm.sh"
  fi
}

nvm() {
  lazy_load_nvm
  nvm $@
}

node() {
  lazy_load_nvm
  node $@
}

npm() {
  lazy_load_nvm
  npm $@
}
