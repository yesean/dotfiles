# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# set environment variables
export PATH="$PATH:/usr/local/sbin"
export PATH="$PATH:/var/lib/snapd/snap/bin"
export PATH="$PATH:$(yarn global bin)"
export QUOTING_STYLE=literal
export FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude "{.git,node_modules}" .'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
export FZF_ALT_C_COMMAND="${FZF_DEFAULT_COMMAND} --type d"

# check linux or macos
[[ $(uname) = 'Darwin' ]] && is_macos=true || is_macos=false
[[ $(uname) = 'Linux' ]] && is_linux=true || is_linux=false

# match hidden files
setopt globdots

# aliases
if [[ "$is_linux" == "true" ]]; then
  alias ls='ls --color=auto'         # list, show hidden
  alias ll='ls --color=auto -lA'   # list, show hidden
elif [[ "$is_macos" == "true" ]]; then
  alias ls='ls -G'         # list, show hidden
  alias ll='ls -lAG'   # list, show hidden
fi
alias vim='nvim'           # neovim
# git gud
alias gd='git diff'
alias gds='git diff --staged'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gcan='git commit --amend --no-edit'
alias gco='git checkout'
alias gb='git branch'
alias ga='git add'
alias gaa='git add -A'
alias gs='git status'
alias gl='git lg'
alias gpu='git push'
alias gpl='git pull'

# homebrew completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi

# enable autocomplete
autoload -Uz compinit promptinit
compinit
promptinit

# enable history search
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

# vim mode
bindkey -v # vi key bindings
export KEYTIMEOUT=1 # reduce vim timeout

# Change cursor with support for inside/outside tmux
function _set_cursor() {
    if [[ $TMUX = '' ]]; then
      echo -ne $1
    else
      echo -ne "\ePtmux;\e\e$1\e\\"
    fi
}

function _set_block_cursor() { _set_cursor '\e[2 q' }
function _set_beam_cursor() { _set_cursor '\e[6 q' }

function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
      _set_block_cursor
  else
      _set_beam_cursor
  fi
}
zle -N zle-keymap-select
# ensure beam cursor when starting new terminal
precmd_functions+=(_set_beam_cursor) #
# ensure insert mode and beam cursor when exiting vim
zle-line-init() { zle -K viins; _set_beam_cursor }

# powerline zsh
if [[ "$is_linux" == "true" ]]; then
  source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme # arch powerline location
elif [[ "$is_macos" == "true" ]]; then
  source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme       # macos powerline location
fi

# powerline10k prompt
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# fzf prompt
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
if [[ "$is_linux" == "true" ]]; then
  source /usr/share/fzf/key-bindings.zsh
  source /usr/share/fzf/completion.zsh
fi

# fzf keybindings
bindkey '^P' fzf-file-widget
bindkey '^O' fzf-cd-widget
bindkey -s '^E' 'vim $(fzf)\n'
