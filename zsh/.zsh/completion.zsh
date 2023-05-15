# completion settings
autoload -Uz compinit && compinit

zstyle ':completion:*' ignored-patterns '*.|*..' # ignore the special dirs . and .. in tab completion
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#5a524c'
