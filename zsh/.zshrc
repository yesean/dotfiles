# set environment variables
export EDITOR=nvim
export BROWSER=brave
export QUOTING_STYLE=literal
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH="/usr/local/opt/python/libexec/bin:$PATH"
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/scripts
export PATH=$PATH:$(yarn global bin)
export PATH=$PATH:$HOME/.toolbox/bin
export PATH=$PATH:$HOME/go/bin
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true

# oh-my-zsh plugins
export ZSH=$HOME/.oh-my-zsh
plugins=(
  archlinux
  brew
  emoji
  evalcache
  extract
  fd
  fzf
  git
  git-extras
  ripgrep
  stack
  tmux
  vi-mode
  zsh-aliases-exa
  zsh-autosuggestions
  zsh-nvm
  zsh-syntax-highlighting
)
fpath+="${ZSH_CUSTOM:-"$ZSH/custom"}/plugins/zsh-completions/src"
source $ZSH/oh-my-zsh.sh

# vi-mode settings
VI_MODE_SET_CURSOR=true
KEYTIMEOUT=1

# fzf settings
export FZF_BASE="/usr/share/fzf"

fd_default_opts='--follow --exclude "{Games,go,R,node_modules}"'
fd_files="fd ${fd_default_opts} -t f ."
fd_dirs="fd ${fd_default_opts} -t d ."

fzf_finder_options='--height 40% --layout=reverse --border'
fzf_file_layout="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
fzf_dir_layout="--preview 'exa -lbhHigUmuSa --no-time  --git --color-scale {}'"

export FZF_DEFAULT_COMMAND=$fd_files
export FZF_DEFAULT_OPTS=$fzf_finder_options

export FZF_CTRL_T_COMMAND=$fd_files
export FZF_CTRL_T_OPTS=$fzf_file_layout

export FZF_ALT_C_COMMAND=$fd_dirs
export FZF_ALT_C_OPTS=$fzf_dir_layout

# completion settings
zstyle ':completion:*' ignored-patterns '*.|*..' # ignore the special dirs . and .. in tab completion
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#5a524c'


# initialize prompt
ZSH_THEME=""
autoload -U promptinit
promptinit
prompt pure

setopt globdots     # match hidden files
setopt extendedglob # add globbing syntax

# key bindings
bindkey '^]' autosuggest-accept
bindkey '^P' fzf-file-widget
bindkey '^O' fzf-cd-widget
bindkey '^R' fzf-history-widget
bindkey '^E' 'vim $(fzf)\n'

# check linux or macos
[[ $(uname) = 'Darwin' ]] && is_macos=true || is_macos=false
[[ $(uname) = 'Linux' ]] && is_linux=true || is_linux=false

# aliases
if [[ "$is_linux" == "true" ]]; then
  alias o='xdg-open'
elif [[ "$is_macos" == "true" ]]; then
  alias o='open'
fi

alias nv='nvim'
alias gl='git lg'
alias gi='grep -i'
alias gs='git status'
alias gcm='git commit -vm'
alias gpl='git pull'
alias pss='ps -ef | grep "PID" | head -1; ps -ef | grep -v "grep" | grep'
alias psm='ps -o rss,vsize,command | head -1; ps -o rss,vsize,command | grep -v "grep" | grep'
alias llg='ll | grep -i'
alias R='R --quiet --no-save'
alias dots='cd ~/.dotfiles/'
alias proj='cd ~/projects/'
alias ucsd='cd ~/gd-ucsd/year\ 3/fall/'
alias ta='tmux attach -t'
alias sc='sc-im'

gpo() {
  git push origin HEAD~$1:main
}

# direnv
_evalcache direnv hook zsh
