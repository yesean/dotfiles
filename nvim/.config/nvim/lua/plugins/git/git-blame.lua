return {
  {
    'f-person/git-blame.nvim',
    config = function()
      vim.g.gitblame_enabled = false
      local map = require('mapping')
      map.n('<leader>gb', map.cmd('GitBlameToggle'))
    end,
  },
}
