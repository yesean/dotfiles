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
