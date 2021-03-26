syntax enable                       " turns on syntax highlighting
filetype plugin indent on           " activate filetype detection
set belloff=all                     " turns off error bells
set softtabstop=2                   " sets tabs 2 spaces long
set shiftwidth=2                    " sets shift indent to 2 spaces
set expandtab                       " converts tabs to spaces
set autoindent                      " maintains indent from prev line
set smartindent                     " intelligently indents based on prev line
set relativenumber                  " display relative line number
set number                          " display current line number
set ruler                           " bottom right ruler
set colorcolumn=80                  " column 80 highlight
set nowrap                          " turn off line wrapping
set noswapfile                      " creates new buffer without swap file
set ignorecase                      " ignores case when searching
set smartcase                       " overrides ignorecase when uppercase is specified
set timeoutlen=1000                 " reduce esc delay (mapping delay)
set ttimeoutlen=0                   " reduce esc delay (keycode delay)
set backspace=indent,eol,start      " enables backspace in insert
set mouse=a                         " enable mouse support
set scrolloff=15                    " start scrolling 15 lines from edge
set exrc                            " automatically source local .vimrc
set nohlsearch                      " turn off search highlighting
set hidden                          " hides all buffers in background
set signcolumn=yes                  " add extra left column for messages
set splitright                      " open vertical splits to the right
set splitbelow                      " open horizontal splits below

" cursor modes
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
else
    let &t_SI = "\e[5 q"
    let &t_EI = "\e[2 q"
endif

" theme
if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors                       " sets correct color codes
endif

" set leader, localleader key to space
let mapleader = " "
let maplocalleader = " "

" change window shortcut
nnoremap <Leader>h :wincmd h<CR>
nnoremap <Leader>j :wincmd j<CR>
nnoremap <Leader>k :wincmd k<CR>
nnoremap <Leader>l :wincmd l<CR>

" disable ale lsp
let g:ale_disable_lsp = 1

" load plugins
call plug#begin('~/.vim/plugged')
Plug 'itchyny/lightline.vim'      " aesthetics
Plug 'arcticicestudio/nord-vim'

Plug 'preservim/nerdtree'         " editing
Plug 'bfrg/vim-cpp-modern'
Plug 'pangloss/vim-javascript'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'lervag/vimtex'
Plug 'alvan/vim-closetag'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'dense-analysis/ale'
Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'tpope/vim-commentary'

Plug 'google/vim-maktaba'         " formatting
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'
call plug#end()

call glaive#Install()
Glaive codefmt plugin[mappings]
Glaive codefmt google_java_executable="/usr/local/bin/google-java-format"

colorscheme nord                          " set colorscheme
let g:nord_cursor_line_number_background = 1
