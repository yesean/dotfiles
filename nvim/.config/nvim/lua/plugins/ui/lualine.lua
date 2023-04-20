return {
  {
    'hoob3rt/lualine.nvim',
    dependencies = {
      'catppuccin/nvim',
    },
    opts = {
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
            path = 1,
          },
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
    },
  },
}