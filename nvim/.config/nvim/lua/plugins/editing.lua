local utils = require('utils')

return {
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {
      modes = {
        search = { enabled = false },
        char = {
          highlight = { backdrop = false },
          autohide = true,
        },
      },
    },
    keys = {
      -- stylua: ignore start
      { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'flash jump', },
      { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'flash treesitter', },
      { 'r', mode = 'o', function() require('flash').remote() end, desc = 'flash remote', },
      { 'R', mode = { 'o', 'x' }, function() require('flash').treesitter_search() end, desc = 'flash treesitter search', },
      -- stylua: ignore end
      {
        '<c-s>',
        mode = { 'c' },
        function()
          require('flash').toggle()
        end,
        desc = 'toggle flash search',
      },
    },
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
    opts = {},
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
