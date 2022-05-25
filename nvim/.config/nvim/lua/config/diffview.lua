local map = require('mapping')
local function DiffviewToggle()
  local view = require('diffview.lib').get_current_view()
  if view then
    return map.cmd('DiffviewClose')
  else
    return map.cmd('DiffviewOpen')
  end
end

map.n('<leader>gd', DiffviewToggle, { expr = true })
map.n('<leader>gdm', map.cmd('DiffviewOpen origin/main'))
