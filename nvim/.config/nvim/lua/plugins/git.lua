return {
  {
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
      map.n(
        '<leader>gd',
        DiffviewToggle,
        { expr = true, desc = 'toggle diffview' }
      )
      map.n('<leader>gdm', map.cmd('DiffviewOpen origin/main'))
    end,
  },
  {
    'f-person/git-blame.nvim',
    keys = {
      { '<leader>gb', '<cmd>GitBlameToggle<cr>', desc = 'toggle git blame' },
    },
  },
  {
    'akinsho/git-conflict.nvim',
    version = '*',
    event = { 'BufRead' },
    opts = { default_mappings = { prev = '[x', next = ']x' } },
    config = true,
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = { untracked = { text = '│' } },
      _extmark_signs = false,
    },
  },
  { 'TimUntersberger/neogit' },
}
