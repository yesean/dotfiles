# source: https://github.com/ohmyzsh/ohmyzsh/blob/7a030f6bd6c15259052c7007020cf3ecf8a3f299/lib/history.zsh#LL35C1-L40C59
# history options

setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data

export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=10000
