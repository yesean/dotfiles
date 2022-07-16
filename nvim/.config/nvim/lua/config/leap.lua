local map = require('mapping')

-- setup leap
require('leap').setup({
  case_sensitive = false,
})
require('leap').set_default_keymaps()

local function leap_bidirectional()
  require('leap').leap({ target_windows = { vim.api.nvim_get_current_win() } })
end

-- Map them to your preferred key, like:
--
map.n('s', leap_bidirectional)
