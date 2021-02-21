" ale settings
let g:ale_linters = {'javascript': ['eslint']}
let g:ale_fixers = ['prettier', 'eslint', 'latexindent']
let g:ale_fix_on_save = 1

" vim prettier
let g:prettier#config#single_quote = 'true'
let g:prettier#config#trailing_comma = 'all'

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
  autocmd FileType html,css,javascript,sass,scss,less,json,vue,typescript,javascriptreact,typescriptreact AutoFormatBuffer prettier
augroup END

