" ale settings
let g:ale_linters = {
\   'javascript':       ['prettier', 'eslint'],
\   'javascriptreact':  ['prettier', 'eslint'],
\   'typescript':       ['prettier', 'eslint'],
\   'typescriptreact':  ['prettier', 'eslint'],
}
let g:ale_fixers = {
\   '*':                ['remove_trailing_lines', 'trim_whitespace'],
\   'tex':              ['latexindent', 'textlint'],
\   'javascript':       ['prettier', 'eslint'],
\   'javascriptreact':  ['prettier', 'eslint'],
\   'typescript':       ['prettier', 'eslint'],
\   'typescriptreact':  ['prettier', 'eslint'],
\}
let g:ale_fix_on_save = 1
let g:ale_set_loclist = 1
let g:ale_open_list = 0
let g:ale_set_highlights = 0  " disable error highlighting

let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
highlight ALEErrorSign ctermbg=NONE ctermfg=red
highlight ALEWarningSign ctermbg=NONE ctermfg=yellow

" jump between errors and warnings
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
