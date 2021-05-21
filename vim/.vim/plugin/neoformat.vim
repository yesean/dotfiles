augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END

" basic formatting
let g:neoformat_basic_format_align = 1
let g:neoformat_basic_format_retab = 1
let g:neoformat_basic_format_trim = 1

let g:neoformat_run_all_formatters = 1
let g:neoformat_only_msg_on_error = 1
