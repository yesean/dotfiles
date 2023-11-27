local utils = require('utils')

return {
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
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
  { 'windwp/nvim-autopairs', config = true },
  { 'kylechui/nvim-surround', version = '*', config = true },
  {
    'windwp/nvim-ts-autotag',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
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
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = 'popup' }
    end,
  },
}
