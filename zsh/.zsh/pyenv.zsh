lazy_load_pyenv() {
  unset -f pyenv python pip
  eval "$(pyenv init -)"
}

pyenv() {
  lazy_load_pyenv
  pyenv $@
}

python() {
  lazy_load_pyenv
  python $@
}

pip() {
  lazy_load_pyenv
  pip $@
}
