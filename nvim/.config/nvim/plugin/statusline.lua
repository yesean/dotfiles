require('lualine').setup({
  options = { theme = 'gruvbox-flat' },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { 'filename' },
    lualine_x = { 'encoding' },
    lualine_y = { 'location' },
    lualine_z = { 'filetype' },
  },
})
