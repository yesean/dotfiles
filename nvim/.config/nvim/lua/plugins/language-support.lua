local utils = require('utils')

return {
  { 'chrisbra/csv.vim' },
  {
    'iamcco/markdown-preview.nvim',
    build = function()
      vim.fn['mkdp#util#install']()
    end,
    config = function()
      vim.g.mkdp_auto_close = false
    end,
  },
  { 'jxnblk/vim-mdx-js' },
  {
    'folke/neodev.nvim',
    cond = not utils.is_vscode,
    opts = {
      -- enable neodev.nvim inside ~/.dotfiles
      override = function(root_dir, options)
        if root_dir:find('dotfiles') then
          options.enabled = true
          options.runtime = true
          options.types = true
          options.plugins = true
        end
      end,
    },
  },
  { 'Fymyte/rasi.vim' },
  {
    'pmizio/typescript-tools.nvim',
    cond = not utils.is_vscode,
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {},
  },
  {
    'dmmulroy/tsc.nvim',
    opts = {
      flags = {
        build = true,
      },
    },
  },
}
