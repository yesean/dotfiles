local utils = require('utils')

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    opts = function()
      return {
        ensure_installed = 'all',
        highlight = {
          enable = not utils.is_vscode,
          disable = function(_, buf)
            local wins = vim.fn.win_findbuf(buf)
            return #wins > 0 and vim.api.nvim_win_get_config(wins[1]).relative ~= ''
          end,
        },
        matchup = {
          enable = true,
        },
      }
    end,
    config = function(_, opts)
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
