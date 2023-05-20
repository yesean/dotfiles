# unbind default fzf keybindings
bindkey -er '^t'
bindkey -vr '^t'
bindkey -ar '^t'
bindkey -er '\ec'
bindkey -vr '\ec'
bindkey -ar '\ec'

bindkey '^P' fzf-file-widget
bindkey '^O' fzf-cd-widget
bindkey '^R' fzf-history-widget
bindkey '^]' autosuggest-accept
