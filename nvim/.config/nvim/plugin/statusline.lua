require('lualine').setup({
  options = { theme = 'onedark' },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { 'filename' },
    lualine_x = { 'encoding' },
    lualine_y = { 'location' },
    lualine_z = { 'filetype' },
  },
})
