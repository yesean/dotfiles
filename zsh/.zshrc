# check linux or macos
[[ $(uname) = 'Darwin' ]] && is_macos=true
[[ $(uname) = 'Linux' ]] && is_linux=true

# load plugins
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load

source ~/.zsh/aliases.zsh
source ~/.zsh/completion.zsh
source ~/.zsh/env.zsh
source ~/.zsh/fzf.zsh
source ~/.zsh/history.zsh
source ~/.zsh/options.zsh

# load keybindings after zsh-vi-mode, otherwise they'll get overwritten
# https://github.com/jeffreytse/zsh-vi-mode#execute-extra-commands
function zvm_after_init() {
  source ~/.zsh/keybindings.zsh
}

eval "$(starship init zsh)"
eval "$(pyenv init -)"

if [[ "$is_linux" == true ]]; then
  source /usr/share/nvm/init-nvm.sh
elif [[ "$is_macos" == true ]]; then
  source "$(brew --prefix)/opt/nvm/nvm.sh"
fi
