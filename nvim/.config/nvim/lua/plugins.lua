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

  -- completion engine
  use('hrsh7th/nvim-cmp')

  -- completion sources
  use('hrsh7th/cmp-nvim-lsp')
  use('saadparwaiz1/cmp_luasnip')
  use('hrsh7th/cmp-nvim-lua')
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

  -- colorscheme
  use('monsonjeremy/onedark.nvim')
  use('savq/melange')
  use('folke/tokyonight.nvim')
  use({ 'ellisonleao/gruvbox.nvim', requires = { 'rktjmp/lush.nvim' } })
  use('eddyekofo94/gruvbox-flat.nvim')

  -- visuals
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
  use('numToStr/Comment.nvim')
  use('JoosepAlviste/nvim-ts-context-commentstring')
  use('blackCauldron7/surround.nvim')

  -- markdown
  use({ 'npxbr/glow.nvim', branch = 'main' })
  use('JamshedVesuna/vim-markdown-preview')
end)
