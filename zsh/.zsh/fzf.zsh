# fzf settings

if [[ "$is_linux" == "true" ]]; then
  fzf_base="/usr/share/fzf"
elif [[ "$is_macos" == "true" ]]; then
  fzf_base="${HOMEBREW}/opt/fzf/shell"
fi

source ${fzf_base}/completion.zsh
source ${fzf_base}/key-bindings.zsh

fd_default_opts='--follow --exclude "{Games,go,R,node_modules}"'
fd_files="fd ${fd_default_opts} -t f ."
fd_dirs="fd ${fd_default_opts} -t d ."

fzf_finder_options='--height 40% --layout=reverse --border --color=bg+:#302D41,bg:#1E1E2E,spinner:#F8BD96,hl:#F28FAD --color=fg:#D9E0EE,header:#F28FAD,info:#DDB6F2,pointer:#F8BD96 --color=marker:#F8BD96,fg+:#F2CDCD,prompt:#DDB6F2,hl+:#F28FAD'
export FZF_DEFAULT_COMMAND=$fd_files
export FZF_DEFAULT_OPTS=$fzf_finder_options

fzf_file_layout="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
export FZF_CTRL_T_COMMAND=$fd_files
export FZF_CTRL_T_OPTS=$fzf_file_layout

fzf_dir_layout="--preview 'eza -lbhHigUmuSa --no-time  --git --color-scale {}'"
export FZF_ALT_C_COMMAND=$fd_dirs
export FZF_ALT_C_OPTS=$fzf_dir_layout
