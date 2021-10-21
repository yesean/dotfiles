require('packer').startup(function()
  -- package manager
  use('wbthomason/packer.nvim')

  -- essentials
  use('nvim-lua/popup.nvim')
  use('nvim-lua/plenary.nvim')
  use('kyazdani42/nvim-web-devicons')

  -- syntax
  use({ 'nvim-treesitter/nvim-treesitter', run = 'TSUpdate' })

  -- lsp
  use('neovim/nvim-lspconfig')
  use('williamboman/nvim-lsp-installer')

  -- completion
  use('hrsh7th/nvim-cmp')
  use('hrsh7th/cmp-nvim-lsp')
  use('saadparwaiz1/cmp_luasnip')
  use('hrsh7th/cmp-path')
  use('hrsh7th/cmp-buffer')

  -- file search
  use('nvim-telescope/telescope.nvim')
  use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })

  -- snippets
  use('L3MON4D3/LuaSnip')
  use('rafamadriz/friendly-snippets')

  -- misc neovim plugins
  use('jose-elias-alvarez/null-ls.nvim')
  use('jose-elias-alvarez/nvim-lsp-ts-utils')

  -- visuals
  use('navarasu/onedark.nvim')
  use('romgrk/barbar.nvim')
  use('kyazdani42/nvim-tree.lua')
  use('hoob3rt/lualine.nvim')
  use('lewis6991/gitsigns.nvim')
  use('onsails/lspkind-nvim')
  use('kosayoda/nvim-lightbulb')
  use('lukas-reineke/indent-blankline.nvim')
  use('haringsrob/nvim_context_vt')
  use('goolord/alpha-nvim')

  -- editing
  use('windwp/nvim-autopairs')
  use('windwp/nvim-ts-autotag')
  use('b3nj5m1n/kommentary')
  use('JoosepAlviste/nvim-ts-context-commentstring')
  use('blackCauldron7/surround.nvim')

  -- markdown
  use({ 'npxbr/glow.nvim', branch = 'main' })
  use('JamshedVesuna/vim-markdown-preview')
end)
