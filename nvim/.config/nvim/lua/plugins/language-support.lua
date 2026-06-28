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
    'folke/lazydev.nvim',
    ft = 'lua',
    cond = not utils.is_vscode,
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Fymyte/rasi.vim' },
  {
    'pmizio/typescript-tools.nvim',
    cond = not utils.is_vscode,
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {
      settings = {
        expose_as_code_action = 'all',
      },
    },
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
