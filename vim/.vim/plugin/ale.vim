" ale settings
let g:ale_linters = {'javascript': ['eslint']}
let g:ale_fixers = ['prettier', 'eslint', 'latexindent']
let g:ale_fix_on_save = 1
let g:ale_set_loclist = 1
let g:ale_open_list = 0

" jump between errors and warnings
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

