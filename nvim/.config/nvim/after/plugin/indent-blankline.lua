-- display certain characters (tab, space, eol, etc)
--[[ vim.opt.list = true
vim.opt.listchars = {
  tab = '. ‣',
  lead = '·',
} ]]

vim.opt.termguicolors = true
vim.cmd([[highlight IndentBlanklineIndent1 guifg=#3f4247 gui=nocombine]])

require('indent_blankline').setup({
  show_end_of_line = true,
  space_char_blankline = ' ',
  char_highlight_list = {
    'IndentBlanklineIndent1',
  },
})
