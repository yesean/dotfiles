local map = require('mapping')

return {
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
    config = function(_, opts)
      require('trouble').setup(opts)

      map.n('<leader>xx', map.cmd('Trouble diagnostics toggle'), { desc = 'diagnostics (project)' })
      map.n('<leader>xX', map.cmd('Trouble diagnostics toggle filter.buf=0'), { desc = 'diagnostics (buffer)' })
      map.n('<leader>xq', map.cmd('Trouble qflist toggle'), { desc = 'quickfix list' })
      map.n('<leader>xl', map.cmd('Trouble loclist toggle'), { desc = 'location list' })
    end,
  },
}
