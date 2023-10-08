# check linux or macos
[[ $(uname) = 'Darwin' ]] && is_macos=true
[[ $(uname) = 'Linux' ]] && is_linux=true

# load plugins
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load

source ~/.zsh/env.zsh
source ~/.zsh/aliases.zsh
source ~/.zsh/completion.zsh
source ~/.zsh/fzf.zsh
source ~/.zsh/history.zsh
source ~/.zsh/keybindings.zsh
source ~/.zsh/nvm.zsh
source ~/.zsh/options.zsh
source ~/.zsh/pyenv.zsh
source ~/.zsh/nvim.zsh # requires functions from nvm.zsh and pyenv.zsh

# load prompt
eval "$(starship init zsh)"
