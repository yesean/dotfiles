" syntastic 
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_tex_checkers = ['chktek']
let g:syntastic_html_checkers = ['validator', 'w3']

" cpp modern highlighting
let g:cpp_attributes_highlight = 1
let g:cpp_member_highlight = 1
let g:cpp_simple_highlight = 1

" vim javascript 
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1
