vim.g.gitblame_enabled = false
local map = require('mapping')
map.n('<leader>gb', map.cmd('GitBlameToggle'))
