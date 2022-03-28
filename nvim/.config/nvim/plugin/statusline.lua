require('lualine').setup({
  options = {
    theme = 'catppuccin',
    globalstatus = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { { 'filename', path = 1, shorting_target = 40 } },
    lualine_x = { 'encoding' },
    lualine_y = { 'location', 'progress' },
    lualine_z = { 'filetype' },
  },
})
