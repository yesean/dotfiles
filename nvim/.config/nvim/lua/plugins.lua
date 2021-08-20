return require('packer').startup(function()
  -- package manager
  use 'wbthomason/packer.nvim'

  -- neovim requirements
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'kyazdani42/nvim-web-devicons'

  -- core neovim plugins
  use { 'nvim-treesitter/nvim-treesitter', run = 'TSUpdate' }
  use 'neovim/nvim-lspconfig'
  use 'kabouzeid/nvim-lspinstall'
  use 'hrsh7th/nvim-compe'
  use 'nvim-telescope/telescope.nvim'

  -- misc neovim plugins
  use 'romgrk/barbar.nvim'
  use 'kyazdani42/nvim-tree.lua'
  use 'hoob3rt/lualine.nvim'
  use 'lewis6991/gitsigns.nvim'
  use 'windwp/nvim-autopairs'
  use 'windwp/nvim-ts-autotag'
  use 'navarasu/onedark.nvim'
  use { 'npxbr/glow.nvim', branch = 'main' }
  use 'b3nj5m1n/kommentary'
  use 'onsails/lspkind-nvim'
  use 'kosayoda/nvim-lightbulb'
  use 'mhartington/formatter.nvim'
  use 'blackCauldron7/surround.nvim'
end)
