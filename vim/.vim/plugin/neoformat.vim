" format on save
let ftToIgnore = ['conf']
augroup fmt
  autocmd!
  autocmd BufWritePre * if index(ftToIgnore, &ft) < 0 | Neoformat
augroup END

" basic formatting
let g:neoformat_basic_format_align = 1
let g:neoformat_basic_format_retab = 1
let g:neoformat_basic_format_trim = 1

let g:neoformat_run_all_formatters = 1
let g:neoformat_only_msg_on_error = 1

let g:neoformat_enabled_javascript = ['tsfmt', 'prettier', 'prettier-eslint', 'tslint', 'eslint_d']
let g:neoformat_enabled_javascriptreact = ['tsfmt', 'prettier', 'prettier-eslint', 'tslint', 'eslint_d']
let g:neoformat_enabled_typescript = ['tsfmt', 'prettier', 'prettier-eslint', 'tslint', 'eslint_d']
let g:neoformat_enabled_typescriptreact = ['tsfmt', 'prettier', 'prettier-eslint', 'tslint', 'eslint_d']
