" coc extensions
let g:coc_global_extensions = ['coc-json', 'coc-git', 'coc-clangd', 'coc-css', 'coc-eslint', 'coc-html', 'coc-java', 'coc-python', 'coc-tsserver', 'coc-texlab', 'coc-yaml']

" use enter for trigger completion
" inoremap <silent><expr> <CR> coc#_select_confirm()

" use tab/shift-tab to navigate suggestions
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
