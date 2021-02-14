call plug#begin('~/.vim/plugged')
" aesthetics
Plug 'itchyny/lightline.vim'
Plug 'arcticicestudio/nord-vim'

" editing
Plug 'preservim/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'bfrg/vim-cpp-modern'
Plug 'pangloss/vim-javascript'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'lervag/vimtex'
Plug 'alvan/vim-closetag'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" formatting
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'
call plug#end()

call glaive#Install()
Glaive codefmt plugin[mappings]
Glaive codefmt google_java_executable="/usr/local/bin/google-java-format"

" set leader, localleader key to space
let mapleader = " "
let maplocalleader = " "

source ~/.dotfiles/vim/coc.vim
source ~/.dotfiles/vim/fzf.vim
source ~/.dotfiles/vim/formatting.vim
source ~/.dotfiles/vim/lightline.vim
source ~/.dotfiles/vim/nerdtree.vim
source ~/.dotfiles/vim/options.vim
source ~/.dotfiles/vim/syntax.vim
source ~/.dotfiles/vim/theme.vim
source ~/.dotfiles/vim/vimtex.vim

" cursor modes
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
else
    let &t_SI = "\e[5 q"
    let &t_EI = "\e[2 q"
endif

" change window shortcut
nnoremap <Leader>h :wincmd h<CR>
nnoremap <Leader>j :wincmd j<CR>
nnoremap <Leader>k :wincmd k<CR>
nnoremap <Leader>l :wincmd l<CR>

