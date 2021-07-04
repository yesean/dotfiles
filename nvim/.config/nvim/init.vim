set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vim/vimrc

lua << EOF

require'nvim-treesitter.configs'.setup { ensure_installed = "maintained", highlight = { enable = true } }

EOF
