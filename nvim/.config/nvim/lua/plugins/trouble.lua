local map = require('mapping')

return {
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
    config = function(_, opts)
      require('trouble').setup(opts)

      map.set({
        {
          key = '<leader>xx',
          cmd = map.cmd('Trouble diagnostics toggle'),
          desc = 'diagnostics (project)',
        },
        {
          key = '<leader>xX',
          cmd = map.cmd('Trouble diagnostics toggle filter.buf=0'),
          desc = 'diagnostics (buffer)',
        },
        {
          key = '<leader>xq',
          cmd = map.cmd('Trouble qflist toggle'),
          desc = 'quickfix list',
        },
        {
          key = '<leader>xl',
          cmd = map.cmd('Trouble loclist toggle'),
          desc = 'location list',
        },
      })
    end,
  },
}
