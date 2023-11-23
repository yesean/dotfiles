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
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {},
  },
}
