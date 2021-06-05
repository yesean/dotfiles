# powerline10k theme
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
ZSH_THEME="powerlevel10k/powerlevel10k"
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# vi-mode settings
VI_MODE_SET_CURSOR=true
KEYTIMEOUT=1

# fzf settings
export FZF_BASE=/usr/share/fzf
export FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude "{.git,node_modules,games}" .'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
export FZF_ALT_C_COMMAND="${FZF_DEFAULT_COMMAND} --type d"

# completion settings
autoload -Uz compinit && compinit
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=1

# oh-my-zsh plugins
export ZSH=$HOME/.oh-my-zsh
plugins=(
  archlinux
  brew
  emoji
  extract
  fd
  fzf
  git
  git-extras
  ripgrep
  stack
  tmux
  vi-mode
  zsh-syntax-highlighting
  zsh-autosuggestions
  zsh-completions
)
source $ZSH/oh-my-zsh.sh

setopt globdots # match hidden files
setopt extendedglob # add globbing syntax

# key bindings
bindkey '^]' autosuggest-accept
bindkey '^P' fzf-file-widget
bindkey '^O' fzf-cd-widget
bindkey '^E' 'vim $(fzf)\n'

# set environment variables
export EDITOR=nvim
export BROWSER=brave
export QUOTING_STYLE=literal
export PATH="$PATH:/usr/local/sbin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/scripts"
export PATH="$PATH:$(yarn global bin)"

# check linux or macos
[[ $(uname) = 'Darwin' ]] && is_macos=true || is_macos=false
[[ $(uname) = 'Linux' ]] && is_linux=true || is_linux=false

# aliases
if [[ "$is_linux" == "true" ]]; then
  alias ls='ls --color=auto'      # list with color
  alias ll='ls -lhA --color=auto' # list with color, show hidden
  alias o='xdg-open'
elif [[ "$is_macos" == "true" ]]; then
  alias ls='ls -G'    # list with color
  alias ll='ls -lhAG' # list with color, show hidden
  alias o='open'
fi

alias nv='nvim'
alias gl='git lg'
alias gi='grep -i'
alias gs='git status'
alias gcm='git commit -vm'
alias gpl='git pull'
alias pss='ps -ef | grep -i'
alias llg='ll | grep -i'
