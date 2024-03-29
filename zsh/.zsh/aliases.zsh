# aliases
alias nv='nvim'
alias se='sudoedit'
alias ls='eza'
alias ll='eza -l'
alias la='eza -la'
alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'

alias ga='git add'
alias gaa='git add -A'
alias gs='git status'
alias gl='git lg'
alias gd='git diff'
alias gds='git diff --staged'
alias gcm='git commit -vm'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gpl='git pull'
alias gp='git push'
alias gr='git restore'
alias lg='lazygit'

alias dc='docker compose'
alias da='docker ps -a'
alias ds='docker image ls'
alias dsp='docker system prune --force'
alias dspa='docker system prune --force --all'

alias pss='ps -ef | grep "PID" | head -1; ps -ef | grep -v "grep" | grep'
alias psm='ps -o rss,vsize,command | head -1; ps -o rss,vsize,command | grep -v "grep" | grep'

alias dots='cd ~/.dotfiles/'
alias copy='xclip -selection clipboard'

gpo() {
  git push origin HEAD~$1:main
}

mecl() {
  git clone git@github.com:yesean/$1 $2
}

p() {
  cd ~/projects/$1
}

mergepdf() {
  ghostscript -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile="$@"
}

solo() {
  nohup "$@" &>/dev/null &
  disown
}

o() {
  if [[ "$is_linux" == "true" ]]; then
    solo xdg-open "$@"
  elif [[ "$is_macos" == "true" ]]; then
    open "$@"
  fi
}
