local gps = require('nvim-gps')

require('lualine').setup({
  options = {
    theme = 'catppuccin',
    globalstatus = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff' },
    lualine_c = {
      {
        'filename',
        symbols = { modified = ' [modified]', readonly = ' [readonly]' },
      },
      { gps.get_location, cond = gps.is_available },
      {
        'diagnostics',
        symbols = {
          error = ' ',
          warn = ' ',
          info = ' ',
          hint = ' ',
        },
      },
    },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
})
