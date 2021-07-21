set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vim/vimrc

lua << EOF

require'nvim-treesitter.configs'.setup { ensure_installed = "maintained", highlight = { enable = true } }
require'nvim-web-devicons'.setup { default = true }
require('telescope').setup{
defaults = {
  vimgrep_arguments = {
    'rg',
    '--color=never',
    '--no-heading',
    '--with-filename',
    '--line-number',
    '--column',
    '--smart-case',
    '--hidden'
    }
  }
}


EOF

" Using Lua functions
nnoremap <C-p> <cmd>lua require('telescope.builtin').find_files({ find_command = { 'fd', '--hidden', '--follow', '--exclude' ,'{.git,node_modules,games}' } })<cr>
nnoremap <C-f> <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
