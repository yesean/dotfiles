let g:lightline = {
  \ 'component_function': {
  \   'filename': 'LightlineFilename',
  \ },
  \ 'colorscheme': 'nord'
  \ }

" show path relative to git repo
function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

