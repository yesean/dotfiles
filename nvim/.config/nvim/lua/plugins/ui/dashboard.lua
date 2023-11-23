return {
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
      { 'folke/persistence.nvim' },
    },
    opts = function()
      return {
        theme = 'hyper',
        config = {
          week_header = {
            enable = true,
          },
          shortcut = {
            {
              icon = '󰏓 ',
              desc = 'restore session',
              key = 'r',
              group = 'DashboardShortCutIcon',
              action = require('persistence').load,
            },
          },
        },
      }
    end,
  },
}
