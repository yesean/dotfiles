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
  use('hrsh7th/cmp-nvim-lsp-document-symbol')
  use('hrsh7th/cmp-emoji')
  use('hrsh7th/cmp-cmdline')
  use('hrsh7th/cmp-nvim-lsp-signature-help')

  -- file search
  use('nvim-telescope/telescope.nvim')
  use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })

  -- snippets
  use('L3MON4D3/LuaSnip')
  use('rafamadriz/friendly-snippets')

  -- diagnoistics
  use('jose-elias-alvarez/null-ls.nvim')

  -- colorscheme
  use('eddyekofo94/gruvbox-flat.nvim')
  use({ 'catppuccin/nvim', as = 'catppuccin' })
  use('rmehri01/onenord.nvim')

  -- visuals
  use('romgrk/barbar.nvim')
  use('kyazdani42/nvim-tree.lua')
  use('hoob3rt/lualine.nvim')
  use('lewis6991/gitsigns.nvim')
  use('onsails/lspkind-nvim')
  use('lukas-reineke/indent-blankline.nvim')
  use('goolord/alpha-nvim')
  use('norcalli/nvim-colorizer.lua')
  use('tpope/vim-surround')

  -- editing
  use('ggandor/lightspeed.nvim')
  use('windwp/nvim-autopairs')
  use('windwp/nvim-ts-autotag')
  use('numToStr/Comment.nvim')
  use('JoosepAlviste/nvim-ts-context-commentstring')
  use({
    'glacambre/firenvim',
    run = function()
      vim.fn['firenvim#install'](0)
    end,
  })

  -- remote editing
  use('chipsenkbeil/distant.nvim')

  -- typescript
  use('jose-elias-alvarez/nvim-lsp-ts-utils')

  -- markdown
  use('iamcco/markdown-preview.nvim')

  -- csv
  use('chrisbra/csv.vim')
end)
