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

setopt globdots               # match hidden files
setopt extendedglob           # add globbing syntax
# source: https://github.com/ohmyzsh/ohmyzsh/blob/7a030f6bd6c15259052c7007020cf3ecf8a3f299/lib/history.zsh#LL35C1-L40C59
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data
