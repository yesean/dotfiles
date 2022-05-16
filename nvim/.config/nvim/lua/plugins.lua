local function config(name)
  return string.format([[require('config.%s')]], name)
end

local function setup(name)
  return string.format([[require('%s').setup({})]], name)
end

require('packer').startup({
  function()
    ----- package manager -----
    use('wbthomason/packer.nvim')

    -----  common dependencies -----
    use('nvim-lua/popup.nvim')
    use('nvim-lua/plenary.nvim')
    use('MunifTanjim/nui.nvim')
    use({
      'kyazdani42/nvim-web-devicons',
      config = function()
        require('nvim-web-devicons').setup({ default = true })
      end,
    })

    ----- syntax + colors -----
    use({
      'nvim-treesitter/nvim-treesitter',
      run = 'TSUpdate',
      config = config('treesitter'),
    })
    use('nvim-treesitter/playground')
    use({
      'catppuccin/nvim',
      as = 'catppuccin',
      config = config('catppuccin'),
    })

    ----- lsp -----
    use('williamboman/nvim-lsp-installer')
    use({
      'neovim/nvim-lspconfig',
      config = config('lsp'),
    })
    use({
      'jose-elias-alvarez/null-ls.nvim',
      config = config('null-ls'),
    })
    use('jose-elias-alvarez/nvim-lsp-ts-utils')
    use('onsails/lspkind-nvim') -- lsp symbols

    ----- autocomplete -----
    use({
      'hrsh7th/nvim-cmp', -- completion engine
      config = config('cmp'),
    })
    use('hrsh7th/cmp-nvim-lsp') -- completion sources
    use('saadparwaiz1/cmp_luasnip')
    use('hrsh7th/cmp-nvim-lua')
    use('hrsh7th/cmp-path')
    use('hrsh7th/cmp-buffer')
    use('hrsh7th/cmp-emoji')
    use('hrsh7th/cmp-cmdline')
    use('hrsh7th/cmp-nvim-lsp-document-symbol')
    use('hrsh7th/cmp-nvim-lsp-signature-help')

    ----- file/grep finder + general purpose picker -----
    use({
      'nvim-telescope/telescope.nvim',
      config = config('telescope'),
    })
    use('nvim-telescope/telescope-ui-select.nvim')
    use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })

    ----- snippets -----
    use({
      'L3MON4D3/LuaSnip',
      config = config('luasnip'),
    })
    use('rafamadriz/friendly-snippets')

    ----- visuals -----
    use({
      'akinsho/bufferline.nvim', -- tabs
      config = config('bufferline'),
    })
    use({
      'nvim-neo-tree/neo-tree.nvim', -- filetree
      branch = 'v2.x',
      config = config('neotree'),
    })
    use({
      'hoob3rt/lualine.nvim', -- statusline
      config = config('lualine'),
    })

    ----- git -----
    use({
      'TimUntersberger/neogit',
      config = setup('neogit'),
    })
    use({
      'sindrets/diffview.nvim',
      config = function()
        local map = require('mapping')
        local function DiffviewToggle()
          local view = require('diffview.lib').get_current_view()
          if view then
            return map.cmd('DiffviewClose')
          else
            return map.cmd('DiffviewOpen')
          end
        end

        map.n('<leader>gd', DiffviewToggle, { expr = true })
        map.n('<leader>gdm', map.cmd('DiffviewOpen origin/main'))
      end,
    })
    use({
      'f-person/git-blame.nvim',
      config = function()
        vim.g.gitblame_enabled = false
        local map = require('mapping')
        map.n('<leader>gb', map.cmd('GitBlameToggle'))
      end,
    })
    use({
      'lewis6991/gitsigns.nvim',
      config = setup('gitsigns'),
    })

    ----- editing -----
    use({
      'ggandor/lightspeed.nvim',
      config = config('lightspeed'),
    })
    use({
      'numToStr/Comment.nvim',
      config = config('comment'),
    })
    use('JoosepAlviste/nvim-ts-context-commentstring')
    use({
      'windwp/nvim-autopairs',
      config = setup('nvim-autopairs'),
    })
    use({
      'windwp/nvim-ts-autotag',
      config = setup('nvim-ts-autotag'),
    })
    use('tpope/vim-surround')

    ----- niceties -----
    use({
      'goolord/alpha-nvim', -- startscreen
      config = function()
        require('alpha').setup(require('alpha.themes.startify').config)
      end,
    })
    use({
      'norcalli/nvim-colorizer.lua', -- color highlighter
      config = setup('colorizer'),
    })
    use('lukas-reineke/indent-blankline.nvim') -- indent columns
    use({
      'iamcco/markdown-preview.nvim',
      run = function()
        vim.fn['mkdp#util#install']()
      end,
    })
    use({
      'numToStr/Navigator.nvim', -- integration with tmux panes
      config = config('navigator'),
    })
    use('famiu/bufdelete.nvim')
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
