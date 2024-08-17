local utils = require('utils')

return {
  {
    'folke/flash.nvim',
    cond = not utils.is_vscode,
    event = 'VeryLazy',
    opts = {
      modes = {
        search = {
          enabled = false,
        },
        char = {
          highlight = {
            backdrop = false,
            matches = false,
          },
          jump_labels = false,
          autohide = true,
        },
      },
      highlight = {
        backdrop = false,
        matches = false,
      },
    },
    keys = {
      -- stylua: ignore start
      { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash', },
      { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter', },
      { 'r', mode = 'o', function() require('flash').remote() end, desc = 'Remote Flash', },
      { 'R', mode = { 'o', 'x' }, function() require('flash').treesitter_search() end, desc = 'Treesitter Search', },
      -- stylua: ignore end
      {
        '<c-s>',
        mode = { 'c' },
        function()
          require('flash').toggle()
        end,
        desc = 'Toggle Flash Search',
      },
    },
  },
  {
    'numToStr/Comment.nvim',
    events = 'VeryLazy',
    dependencies = {
      {
        'JoosepAlviste/nvim-ts-context-commentstring',
        opts = { enable_autocmd = false },
      },
    },
    opts = function()
      return {
        pre_hook = require(
          'ts_context_commentstring.integrations.comment_nvim'
        ).create_pre_hook(),
      }
    end,
  },
  {
    'windwp/nvim-autopairs',
    cond = not utils.is_vscode,
    event = 'InsertEnter',
    opts = {},
  },
  {
    'kylechui/nvim-surround',
    version = '*',
    opts = {},
  },
  {
    'windwp/nvim-ts-autotag',
    cond = not utils.is_vscode,
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },
  {
    'RRethy/vim-illuminate',
    cond = not utils.is_vscode,
    opts = { filetypes_denylist = { 'TelescopePrompt' } },
    config = function(_, opts)
      require('illuminate').configure(opts)
    end,
  },
  {
    'andymass/vim-matchup',
    cond = not utils.is_vscode,
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = 'popup' }
    end,
  },
}
