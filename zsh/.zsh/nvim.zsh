# mason.nvim requires npm/pip to be available
nvim() {
  unset -f nvim
  lazy_load_nvm
  lazy_load_pyenv
  nvim $@
}
