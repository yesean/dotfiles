local nvim_tree = require('nvim-tree')
local maps = require('maps')

local tree_width = 40

function Toggle_Tree()
  nvim_tree.toggle()
  if require('nvim-tree.view').is_visible() then
    require('bufferline.state').set_offset(tree_width, 'FileTree')
    nvim_tree.find_file(true)
  else
    require('bufferline.state').set_offset(0)
  end
end

maps.n('<leader>n', '<cmd>lua Toggle_Tree()<cr>')

nvim_tree.setup({
  auto_close = true,
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  view = {
    width = tree_width,
    relativenumber = true,
    mappings = {
      list = {
        {
          key = 'a',
          action = 'create',
          action_cb = function(node)
            require('nvim-tree.actions.create-file').fn(node)
            vim.cmd('LspRestart')
          end,
        },
      },
    },
  },
})

return { Toggle_Tree }
