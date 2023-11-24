return {
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    config = function(_, opts)
      local persistence = require('persistence')

      persistence.setup(opts)
      vim.api.nvim_create_autocmd('BufEnter', {
        desc = 'save neovim session whenever a buffer is opened',
        group = 'persistence',
        callback = function()
          persistence.save()
        end,
      })
    end,
  },
}
