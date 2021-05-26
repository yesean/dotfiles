" ale settings
let g:ale_linters = {
\   'javascript':       ['eslint'],
\   'javascriptreact':  ['eslint'],
\   'typescript':       ['eslint'],
\   'typescriptreact':  ['eslint'],
\}
let g:ale_fixers = {
\   '*':                ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript':       ['prettier', 'eslint'],
\   'javascriptreact':  ['prettier', 'eslint'],
\   'markdown':         ['prettier'],
\   'tex':              ['latexindent', 'textlint'],
\   'typescript':       ['prettier', 'eslint'],
\   'typescriptreact':  ['prettier', 'eslint'],
\}
let g:ale_javascript_prettier_options = '--prose-wrap always'
let g:ale_languagetool_options = "--disable 'DASH_RULE[1],DASH_RULE[2],WHITESPACE_RULE'"
let g:ale_fix_on_save = 1
let g:ale_set_loclist = 1
let g:ale_open_list = 0
let g:ale_set_highlights = 0  " disable error highlighting

" change ale symbols and colors
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
highlight ALEErrorSign ctermbg=NONE ctermfg=red
highlight ALEWarningSign ctermbg=NONE ctermfg=yellow

" linter output formatting
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" jump between errors and warnings
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
