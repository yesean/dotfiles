return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    opts = function()
      local commands = require('neo-tree.sources.filesystem.commands')
      return {
        close_if_last_window = true,
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
          },
          follow_current_file = true,
          hijack_netrw_behavior = 'open_current',
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
      }
    end,
    config = function(_, opts)
      local map = require('mapping')
      map.n('<leader>n', map.cmd('Neotree toggle'))

      require('neo-tree').setup(opts)
    end,
  },
}
