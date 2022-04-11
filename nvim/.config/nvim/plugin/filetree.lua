local map = require('mapping')
local commands = require('neo-tree.sources.filesystem.commands')

map.n('<leader>n', map.cmd('Neotree toggle'))

vim.g.neo_tree_remove_legacy_commands = true
require('neo-tree').setup({
  -- close_if_last_window = true,
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
    },
    follow_current_file = true,
  },
  window = {
    mappings = {
      ['<space>'] = 'none',
      ['<cr>'] = function(state)
        local node = state.tree:get_node()
        if node.type == 'file' then
          commands.open(state)
        elseif node.type == 'directory' then
          commands.toggle_node(state)
        end
      end,
    },
  },
})
