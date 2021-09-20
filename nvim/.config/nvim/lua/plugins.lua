return require('packer').startup(function()
  -- package manager
  use('wbthomason/packer.nvim')

  -- neovim requirements
  use('nvim-lua/popup.nvim')
  use('nvim-lua/plenary.nvim')
  use('kyazdani42/nvim-web-devicons')

  -- core neovim plugins
  use({ 'nvim-treesitter/nvim-treesitter', run = 'TSUpdate' })
  use('neovim/nvim-lspconfig')
  use('kabouzeid/nvim-lspinstall')
  use('hrsh7th/nvim-compe')
  use('nvim-telescope/telescope.nvim')
  use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })

  -- misc neovim plugins
  use('folke/trouble.nvim')
  use('jose-elias-alvarez/null-ls.nvim')
  use('jose-elias-alvarez/nvim-lsp-ts-utils')
  use('romgrk/barbar.nvim')
  use('kyazdani42/nvim-tree.lua')
  use('hoob3rt/lualine.nvim')
  use('lewis6991/gitsigns.nvim')
  use('windwp/nvim-autopairs')
  use('windwp/nvim-ts-autotag')
  use('navarasu/onedark.nvim')
  use({ 'npxbr/glow.nvim', branch = 'main' })
  use('b3nj5m1n/kommentary')
  use('JoosepAlviste/nvim-ts-context-commentstring')
  use('onsails/lspkind-nvim')
  use('kosayoda/nvim-lightbulb')
  use('blackCauldron7/surround.nvim')
  use('lukas-reineke/indent-blankline.nvim')
  use('numtostr/FTerm.nvim')
  use('haringsrob/nvim_context_vt')
  use('goolord/alpha-nvim')

  -- vim plugins
  use('SirVer/ultisnips')
  use('mlaursen/vim-react-snippets')
  use('JamshedVesuna/vim-markdown-preview')
end)
