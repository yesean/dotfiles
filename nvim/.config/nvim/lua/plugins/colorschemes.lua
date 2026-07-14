local map = require('mapping')

return {
  {
    'catppuccin/nvim',
    lazy = false,
    opts = { flavour = 'macchiato' },
    config = function(_, opts)
      require('catppuccin').setup(opts)
    end,
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    opts = {},
    config = function(_, opts)
      require('tokyonight').setup(opts)
    end,
  },
  {
    'neanias/everforest-nvim',
    lazy = false,
    version = false,
  },
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = false,
    opts = { variant = 'main', styles = { italic = false } },
    config = function(_, opts)
      require('rose-pine').setup(opts)
    end,
  },
  {
    'rebelot/kanagawa.nvim',
    lazy = false,
    opts = {},
    config = function(_, opts)
      require('kanagawa').setup(opts)
    end,
  },
  {
    'ellisonleao/gruvbox.nvim',
    lazy = false,
    opts = {},
    config = function(_, opts)
      require('gruvbox').setup(opts)
    end,
  },
  {
    'EdenEast/nightfox.nvim',
    lazy = false,
    opts = {},
    config = function(_, opts)
      require('nightfox').setup(opts)
    end,
  },
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    config = function()
      vim.g.gruvbox_material_background = 'medium'
      vim.g.gruvbox_material_enable_italic = true
    end,
  },
  {
    'olimorris/onedarkpro.nvim',
    lazy = false,
    opts = {},
    config = function(_, opts)
      require('onedarkpro').setup(opts)
    end,
  },
  { 'shaunsingh/nord.nvim', lazy = false },
  { 'nyoom-engineering/oxocarbon.nvim', lazy = false },
  {
    dir = vim.fn.expand('~/.dotfiles/nvim-plugins/theme-picker.nvim'),
    name = 'theme-picker',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'catppuccin/nvim',
      'folke/tokyonight.nvim',
      'neanias/everforest-nvim',
      'rose-pine',
      'rebelot/kanagawa.nvim',
      'ellisonleao/gruvbox.nvim',
      'EdenEast/nightfox.nvim',
      'sainnhe/gruvbox-material',
      'olimorris/onedarkpro.nvim',
      'shaunsingh/nord.nvim',
      'nyoom-engineering/oxocarbon.nvim',
    },
    config = function()
      require('theme-picker').setup()
      map.set({
        {
          key = '<leader>cs',
          cmd = function()
            require('theme-picker').open_picker()
          end,
          desc = 'switch colorscheme',
        },
      })
    end,
  },
}
