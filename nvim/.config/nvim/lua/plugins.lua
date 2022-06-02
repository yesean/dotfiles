-- load plugin config file from `lua/config/` folder
local function config(name)
  return string.format([[require('config.%s')]], name)
end

-- setup plugin with empty argument
local function setup(name, empty)
  return string.format([[require('%s').setup(%s)]], name, empty and '' or '{}')
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

    ----- syntax + treesitter integrations -----
    use({
      'nvim-treesitter/nvim-treesitter',
      run = 'TSUpdate',
      config = config('treesitter'),
    })
    use('nvim-treesitter/playground')
    use({ 'catppuccin/nvim', as = 'catppuccin', config = config('catppuccin') })
    use('p00f/nvim-ts-rainbow')
    use({ 'SmiteshP/nvim-gps', config = setup('nvim-gps') })
    use({ 'andymass/vim-matchup', config = config('vim-matchup') })

    ----- lsp -----
    use('williamboman/nvim-lsp-installer')
    use({ 'neovim/nvim-lspconfig', config = config('lsp') })
    use({ 'jose-elias-alvarez/null-ls.nvim', config = config('null-ls') })
    use('jose-elias-alvarez/nvim-lsp-ts-utils')
    use('onsails/lspkind-nvim') -- lsp symbols

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
    use('nvim-telescope/telescope-ui-select.nvim')
    use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })

    ----- snippets -----
    use({ 'L3MON4D3/LuaSnip', config = config('luasnip') })
    use('rafamadriz/friendly-snippets')

    ----- visuals -----
    use({ 'akinsho/bufferline.nvim', config = config('bufferline') }) -- tabs
    use({
      'nvim-neo-tree/neo-tree.nvim', -- filetree
      branch = 'v2.x',
      config = config('neotree'),
    })
    use({ 'hoob3rt/lualine.nvim', config = config('lualine') }) -- statusline

    ----- git -----
    use({ 'TimUntersberger/neogit', config = setup('neogit') })
    use({ 'sindrets/diffview.nvim', config = config('diffview') })
    use({ 'f-person/git-blame.nvim', config = config('gitblame') })
    use({ 'lewis6991/gitsigns.nvim', config = setup('gitsigns') })

    ----- editing -----
    use({ 'ggandor/lightspeed.nvim', config = config('lightspeed') })
    use({ 'numToStr/Comment.nvim', config = config('comment') })
    use('JoosepAlviste/nvim-ts-context-commentstring')
    use({ 'windwp/nvim-autopairs', config = setup('nvim-autopairs') })
    use({ 'windwp/nvim-ts-autotag', config = setup('nvim-ts-autotag') })
    use('tpope/vim-surround')

    ----- niceties -----
    use({
      'goolord/alpha-nvim', -- startscreen
      config = function()
        require('alpha').setup(require('alpha.themes.theta').config)
      end,
    })
    use({ 'norcalli/nvim-colorizer.lua', config = setup('colorizer', true) }) -- color highlighter
    use('lukas-reineke/indent-blankline.nvim') -- indent columns
    use({ 'iamcco/markdown-preview.nvim', run = vim.fn['mkdp#util#install'] })
    use({ 'numToStr/Navigator.nvim', config = config('navigator') }) -- integration with tmux panes
    use('famiu/bufdelete.nvim')
    use('chrisbra/csv.vim')
    use({ 'rmagatti/auto-session', config = setup('auto-session') })
    use({ 'folke/which-key.nvim', config = setup('which-key') })
    use('skywind3000/asyncrun.vim')
    use('lambdalisue/suda.vim')
  end,
  config = {
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'single' })
      end,
    },
  },
})
