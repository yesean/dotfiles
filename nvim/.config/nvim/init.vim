lua << EOF
vim.g['nvim_tree_follow'] = 1
vim.g['nvim_tree_auto_close'] = 1
vim.g['nvim_tree_highlight_opened_files'] = 1
EOF

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vim/vimrc
