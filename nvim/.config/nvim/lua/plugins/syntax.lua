local utils = require('utils')

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      -- enable native treesitter highlighting for all filetypes;
      -- skip float windows to avoid nil-node crash in injection queries
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          if utils.is_vscode then
            return
          end
          local wins = vim.fn.win_findbuf(args.buf)
          local is_float = #wins > 0
            and vim.api.nvim_win_get_config(wins[1]).relative ~= ''
          if not is_float then
            pcall(vim.treesitter.start, args.buf)
          end
        end,
      })

      -- always use jsonc parser for .json files
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = '*.json',
        callback = function()
          vim.bo.filetype = 'jsonc'
        end,
      })
    end,
  },
}
