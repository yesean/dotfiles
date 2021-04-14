" fzf hotkey
function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

command! ProjectFiles execute 'Files' s:find_git_root()
command! -bang -nargs=* PRg
  \ call fzf#vim#grep("rg --hidden -g '!{.git,.node_modules}' --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'dir': system('git rev-parse --show-toplevel 2> /dev/null')[:-2]}, <bang>0)

nnoremap <C-p> :ProjectFiles<CR>
nnoremap <C-t> :Files<CR>
nnoremap <C-f> :PRg<CR>
nnoremap <C-s> :Rg<CR>
