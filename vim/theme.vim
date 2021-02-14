" theme
if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors                       " sets correct color codes
endif
set background=dark                       " sets background color
colorscheme nord                          " set colorscheme
let g:nord_cursor_line_number_background = 1

