" plugins
call plug#begin('~/.vim/plugged')
" aesthetics
Plug 'itchyny/lightline.vim'
Plug 'arcticicestudio/nord-vim'

" editing
Plug 'preservim/nerdtree'
Plug 'valloric/youcompleteme'
Plug 'scrooloose/syntastic'
Plug 'bfrg/vim-cpp-modern'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'kien/ctrlp.vim'
Plug 'jiangmiao/auto-pairs'

" formatting
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'

" specific languages
Plug 'pangloss/vim-javascript'
call plug#end()

call glaive#Install()
" Optional: Enable codefmt's default mappings on the <Leader>= prefix.
Glaive codefmt plugin[mappings]
Glaive codefmt google_java_executable="java -jar /path/to/google-java-format-VERSION-all-deps.jar"

syntax enable                       " turns on syntax highlighting
filetype plugin indent on           " activate filetype detection
set belloff=all                     " turns off error bells
set softtabstop=2                   " sets tabs 4 spaces long
set shiftwidth=2                    " sets shift indent to 4 spaces
set expandtab                       " converts tabs to spaces
set autoindent                      " maintains indent from prev line
set smartindent                     " intelligently indents based on prev line
set nu rnu                          " relative line numbers
set cc=80                           " column 80 highlight
set ruler                           " bottom right ruler
set noswapfile                      " creates new buffer without swap file
set backspace=indent,eol,start      " enables backspace in insert
set smartcase                       " overrides ignorecase with uppercase searches
set incsearch                       " searches as you type a query
set hlsearch                        " highlights all search matches
set timeoutlen=1000                 " reduce esc delay (mapping delay)
set ttimeoutlen=0                   " reduce esc delay (keycode delay)
set mouse=a                         " enable mouse support

" cursor modes
let &t_SI.="\e[5 q"             " blinking vertical in insert
let &t_SR.="\e[4 q"             " solid underscore in replace
let &t_EI.="\e[2 q"             " blinking block in normal

" set leader key
let mapleader=" "

" nerdtree shortcut
noremap <leader>n :NERDTree<CR>

" ycm cpp
let g:ycm_global_ycm_extra_conf = '$HOME/.vim/ycm_extra_conf/ycm_extra_conf.py'

" ctrlp
let g:ctrlp_working_path_mode = 'ra'

" theme
if has('termguicolors')
  set termguicolors                       " sets correct color codes
endif
set background=dark                       " sets background color
colorscheme nord                          " set colorscheme
let g:nord_cursor_line_number_background = 1

" lightline
set laststatus=2
let g:lightline = {
  \ 'colorscheme': 'nord',
  \ }

" syntastic 
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']

" cpp modern highlighting
let g:cpp_attributes_highlight = 1
let g:cpp_member_highlight = 1
let g:cpp_simple_highlight = 1

" vim javascript 
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1

" vim prettier
let g:prettier#config#single_quote = 'true'
let g:prettier#config#trailing_comma = 'all'

" ycm setttings
let g:ycm_autoclose_preview_window_after_insertion=1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1

" vim codefmt
augroup autoformat_settings
  autocmd FileType bzl AutoFormatBuffer buildifier
  autocmd FileType c,cpp,proto,arduino AutoFormatBuffer clang-format
  autocmd FileType dart AutoFormatBuffer dartfmt
  autocmd FileType go AutoFormatBuffer gofmt
  autocmd FileType gn AutoFormatBuffer gn
  autocmd FileType java AutoFormatBuffer google-java-format
  autocmd FileType python AutoFormatBuffer yapf
  autocmd FileType rust AutoFormatBuffer rustfmt
  autocmd FileType html,css,javascript,sass,scss,less,json,vue AutoFormatBuffer prettier
augroup END

