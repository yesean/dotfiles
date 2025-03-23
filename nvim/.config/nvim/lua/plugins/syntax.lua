local utils = require('utils')

return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function()
      return {
        ensure_installed = 'all',
        highlight = {
          enable = not utils.is_vscode,
        },
        rainbow = {
          enable = true,
          extended_mode = true,
        },
        matchup = {
          enable = true,
        },
      }
    end,
    config = function(_, opts)
      vim.o.foldmethod = 'expr'
      vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
      vim.o.foldenable = false

      -- always use jsonc parser
      vim.api.nvim_create_autocmd({ 'BufEnter' }, {
        pattern = '*.json',
        callback = function()
          vim.bo.filetype = 'jsonc'
        end,
      })

      require('nvim-treesitter.configs').setup(opts)
    end,
  },
}
