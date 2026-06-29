local map = require('mapping')

return {
  {
    'sindrets/diffview.nvim',
    config = function()
      local function DiffviewToggle()
        local view = require('diffview.lib').get_current_view()
        if view then
          return map.cmd('DiffviewClose')
        else
          return map.cmd('DiffviewOpen')
        end
      end
      map.set({
        {
          key = '<leader>gd',
          cmd = DiffviewToggle,
          expr = true,
          desc = 'toggle diffview',
        },
        {
          key = '<leader>gdm',
          cmd = map.cmd('DiffviewOpen origin/main'),
          desc = 'open diffview on main',
        },
      })
    end,
  },
  {
    'f-person/git-blame.nvim',
    config = function()
      map.set({
        {
          key = '<leader>gb',
          cmd = '<cmd>GitBlameToggle<cr>',
          desc = 'toggle git blame',
        },
      })
    end,
  },
  {
    'akinsho/git-conflict.nvim',
    version = '*',
    event = { 'BufRead' },
    opts = { default_mappings = { prev = '[x', next = ']x' } },
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = { untracked = { text = '│' } },
    },
  },
  { 'TimUntersberger/neogit', opts = {} },
}
