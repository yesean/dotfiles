# check linux or macos
[[ $(uname) = 'Darwin' ]] && is_macos=true || is_macos=false
[[ $(uname) = 'Linux' ]] && is_linux=true || is_linux=false

source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load

source ~/.zsh/env.zsh
source ~/.zsh/fzf.zsh
source ~/.zsh/completion.zsh
source ~/.zsh/aliases.zsh

function zvm_after_init() {
  source ~/.zsh/keybindings.zsh
}

eval "$(starship init zsh)"
eval "$(pyenv init -)"

setopt globdots     # match hidden files
setopt extendedglob # add globbing syntax
