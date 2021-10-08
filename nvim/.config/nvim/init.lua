vim.cmd([[autocmd VimEnter * :silent exec "!kill -s SIGWINCH $PPID"]]) -- hotfix for window resizing bug
require('settings')
require('maps')
require('plugins')
