# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# set environment variables
export PATH=$PATH:/home/sean/.cargo/bin
export QUOTING_STYLE=literal

# match hidden files
setopt globdots

# aliases
alias ll='ls -la' # long list hidden files shortcut
alias vim='nvim' # neovim as vim
alias g='git' # git as g

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
function zle-keymap-select zle-line-init # change cursor based on vi mode
{
    # change cursor shape
    case $KEYMAP in
        vicmd)      print -n -- "\E]50;CursorShape=0\C-G";;  # block cursor
        viins|main) print -n -- "\E]50;CursorShape=1\C-G";;  # line cursor
    esac

    zle reset-prompt
    zle -R
}
function zle-line-finish
{
    print -n -- "\E]50;CursorShape=0\C-G"  # block cursor
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

# powerline zsh
source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme 2> /dev/null
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme 2> /dev/null

# powerline10k prompt
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
