require('packer').startup({
  function()
    -- package manager
    use('wbthomason/packer.nvim')

    -- essentials
    use('nvim-lua/popup.nvim')
    use('nvim-lua/plenary.nvim')
    use('MunifTanjim/nui.nvim')
    use({
      'kyazdani42/nvim-web-devicons',
      config = function()
        require('nvim-web-devicons').setup({ default = true })
      end,
    })

    -- syntax
    use({
      'nvim-treesitter/nvim-treesitter',
      run = 'TSUpdate',
      config = function()
        require('config.treesitter')
      end,
    })

    -- lsp
    use('williamboman/nvim-lsp-installer')
    use({
      'neovim/nvim-lspconfig',
      config = function()
        require('config.lsp')
      end,
    })

    -- completion engine
    use({
      'hrsh7th/nvim-cmp',
      config = function()
        require('config.cmp')
      end,
    })

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
    use({
      'nvim-telescope/telescope.nvim',
      config = function()
        require('config.telescope')
      end,
    })
    use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })

    -- snippets
    use({
      'L3MON4D3/LuaSnip',
      config = function()
        require('config.luasnip')
      end,
    })
    use('rafamadriz/friendly-snippets')

    -- diagnoistics
    use({
      'jose-elias-alvarez/null-ls.nvim',
      config = function()
        require('config.null-ls')
      end,
    })

    -- colorscheme
    use({
      'catppuccin/nvim',
      as = 'catppuccin',
      config = function()
        require('config.catppuccin')
      end,
    })

    -- visuals
    use({
      'noib3/nvim-cokeline',
      config = function()
        require('config.cokeline')
      end,
    })
    use({
      'nvim-neo-tree/neo-tree.nvim',
      branch = 'v2.x',
      config = function()
        require('config.neotree')
      end,
    })
    use({
      'hoob3rt/lualine.nvim',
      config = function()
        require('config.lualine')
      end,
    })
    use({
      'lewis6991/gitsigns.nvim',
      config = function()
        require('gitsigns').setup()
      end,
    })
    use('onsails/lspkind-nvim')
    use('lukas-reineke/indent-blankline.nvim')
    use({
      'goolord/alpha-nvim',
      config = function()
        require('alpha').setup(require('alpha.themes.startify').opts)
      end,
    })
    use({
      'norcalli/nvim-colorizer.lua',
      config = function()
        require('colorizer').setup()
      end,
    })
    use('tpope/vim-surround')
    use('kdheepak/lazygit.nvim')

    -- editing
    use({
      'ggandor/lightspeed.nvim',
      config = function()
        require('config.lightspeed')
      end,
    })
    use({
      'windwp/nvim-autopairs',
      config = function()
        require('nvim-autopairs').setup()
      end,
    })
    use({
      'windwp/nvim-ts-autotag',
      config = function()
        require('nvim-ts-autotag').setup()
      end,
    })
    use({
      'numToStr/Comment.nvim',
      config = function()
        require('config.comment')
      end,
    })
    use({
      'glacambre/firenvim',
      run = function()
        vim.fn['firenvim#install'](0)
      end,
      config = function()
        require('config.firenvim')
      end,
    })

    -- remote editing
    use({
      'chipsenkbeil/distant.nvim',
      config = function()
        require('config.distant')
      end,
    })
    use('untitled-ai/jupyter_ascending.vim')
    use('jose-elias-alvarez/nvim-lsp-ts-utils')
    use('JoosepAlviste/nvim-ts-context-commentstring')
    use('iamcco/markdown-preview.nvim') -- markdown
    use('chrisbra/csv.vim')
  end,
  config = {
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'single' })
      end,
    },
  },
})
