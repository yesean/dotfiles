# completion settings
autoload -Uz compinit && compinit

zstyle ':completion:*' ignored-patterns '*.|*..'        # ignore the special dirs . and .. in tab completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # case insentive matching https://superuser.com/questions/1092033/how-can-i-make-zsh-tab-completion-fix-capitalization-errors-for-directories-and

export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#5a524c'
