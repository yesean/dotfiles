-- load plugin config file from `lua/config/` folder
local function config(name)
  return string.format([[require('config.%s')]], name)
end

-- setup plugin with empty argument
local function setup(name, empty)
  return string.format([[require('%s').setup(%s)]], name, empty and '' or '{}')
end

local is_nvim = vim.g.vscode == nil

require('packer').startup({
  function()
    ----- package manager -----
    use('wbthomason/packer.nvim')

    -----  common dependencies -----
    use('nvim-lua/popup.nvim')
    use('nvim-lua/plenary.nvim')
    use('MunifTanjim/nui.nvim')
    use({
      'stevearc/dressing.nvim',
      config = function()
        require('dressing').setup({
          input = {
            insert_only = false,
          },
          select = {
            backend = { 'nui' },
          },
        })
      end,
    })
    use({
      'kyazdani42/nvim-web-devicons',
      config = function()
        require('nvim-web-devicons').setup({ default = true })
      end,
    })

    ----- syntax + treesitter integrations -----
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
      cond = is_nvim,
    })
    use('p00f/nvim-ts-rainbow')
    use({
      'SmiteshP/nvim-navic',
      config = function()
        vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
        vim.g.navic_silence = true
      end,
    })
    use({ 'andymass/vim-matchup', config = config('vim-matchup') })

    ----- lsp -----
    use('williamboman/nvim-lsp-installer')
    use({ 'neovim/nvim-lspconfig', config = config('lsp') })
    use({ 'jose-elias-alvarez/null-ls.nvim', config = config('null-ls') })
    use('jose-elias-alvarez/typescript.nvim')
    use('onsails/lspkind-nvim') -- lsp symbols
    use({
      'weilbith/nvim-code-action-menu',
      cmd = 'CodeActionMenu',
    })
    use({ 'j-hui/fidget.nvim', config = setup('fidget') })
    use({
      'kosayoda/nvim-lightbulb',
      requires = 'antoinemadec/FixCursorHold.nvim',
      config = function()
        require('nvim-lightbulb').setup({ autocmd = { enabled = true } })
      end,
    })

    ----- autocomplete -----
    use({ 'hrsh7th/nvim-cmp', config = config('cmp') }) -- completion engine
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
    use({ 'nvim-telescope/telescope.nvim', config = config('telescope') })
    use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })

    ----- snippets -----
    use({ 'L3MON4D3/LuaSnip', config = config('luasnip') })
    use('rafamadriz/friendly-snippets')

    ----- visuals -----
    use({ 'tiagovla/scope.nvim', config = setup('scope') })
    use({
      'akinsho/bufferline.nvim',
      config = config('bufferline'),
      after = 'catppuccin',
    }) -- tabs
    use({
      'nvim-neo-tree/neo-tree.nvim', -- filetree
      branch = 'v2.x',
      config = config('neotree'),
    })
    use({
      'hoob3rt/lualine.nvim',
      config = config('lualine'),
      after = 'catppuccin',
    }) -- statusline

    ----- git -----
    use({ 'TimUntersberger/neogit', config = setup('neogit') })
    use({ 'sindrets/diffview.nvim', config = config('diffview') })
    use({ 'f-person/git-blame.nvim', config = config('gitblame') })
    use({ 'lewis6991/gitsigns.nvim', config = setup('gitsigns') })

    ----- editing -----
    use({ 'ggandor/leap.nvim', config = config('leap') })
    use({ 'numToStr/Comment.nvim', config = config('comment') })
    use('JoosepAlviste/nvim-ts-context-commentstring')
    use({ 'windwp/nvim-autopairs', config = setup('nvim-autopairs') })
    use({ 'windwp/nvim-ts-autotag', config = setup('nvim-ts-autotag') })
    use({
      'kylechui/nvim-surround',
      config = setup('nvim-surround'),
    })
    use({
      'kevinhwang91/nvim-ufo',
      requires = 'kevinhwang91/promise-async',
      config = function()
        vim.o.foldcolumn = '1'
        vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
        vim.o.foldlevelstart = -1
        vim.o.foldenable = true
        vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
        require('ufo').setup()
      end,
    })

    ----- niceties -----
    use({
      'akinsho/toggleterm.nvim',
      tag = 'v2.*',
      config = function()
        require('toggleterm').setup({
          size = 25,
          open_mapping = '<c-`>',
        })
      end,
    })
    use({ 'norcalli/nvim-colorizer.lua', config = setup('colorizer', true) }) -- color highlighter
    use('lukas-reineke/indent-blankline.nvim') -- indent columns
    use({ 'iamcco/markdown-preview.nvim', run = vim.fn['mkdp#util#install'] })
    use('famiu/bufdelete.nvim')
    use('chrisbra/csv.vim')
    use({
      'rmagatti/auto-session',
      config = function()
        require('auto-session').setup({
          pre_save_cmds = { 'Neotree close' },
        })
        vim.o.sessionoptions =
        'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal'
      end,
    })
    use({ 'folke/which-key.nvim', config = setup('which-key') })
    use('skywind3000/asyncrun.vim')
    use('lambdalisue/suda.vim')
    use({
      'rktjmp/highlight-current-n.nvim',
      config = function()
        vim.keymap.set('n', 'n', '<Plug>(highlight-current-n-n)')
        vim.keymap.set('n', 'N', '<Plug>(highlight-current-n-N)')
        vim.api.nvim_create_augroup('ClearSearchHL', {})
        vim.api.nvim_create_autocmd({ 'CmdlineEnter' }, {
          command = 'set hlsearch',
          group = 'ClearSearchHL',
        })
        vim.api.nvim_create_autocmd({ 'CmdlineLeave' }, {
          command = 'set nohlsearch',
          group = 'ClearSearchHL',
        })
      end,
    })
    use({ 'petertriho/nvim-scrollbar', config = setup('scrollbar') })
  end,
  config = {
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'single' })
      end,
    },
  },
})
