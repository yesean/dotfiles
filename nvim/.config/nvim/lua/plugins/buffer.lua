return {
  { 'famiu/bufdelete.nvim' },
  {
    'akinsho/bufferline.nvim',
    opts = {
      options = {
        max_name_length = 30,
        separator_style = 'slant',
        show_close_icons = false,
        show_buffer_close_icons = false,
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'File Explorer',
            text_align = 'center',
          },
        },
        custom_filter = function(buffer)
          -- hide quickfix buffers
          if vim.bo[buffer].filetype == 'qf' then
            return false
          end

          -- hide "[No Name]" buffers
          if vim.fn.bufname(buffer) == '' then
            return false
          end

          return true
        end,
      },
    },
    config = function(_, opts)
      local map = require('mapping')
      map.set({
        {
          key = '<c-y>',
          cmd = map.cmd('BufferLinePick'),
          desc = 'select a buffer by key',
        },
        {
          key = '<c-h>',
          cmd = map.cmd('BufferLineCyclePrev'),
          desc = 'go to one buffer left',
        },
        {
          key = '<c-l>',
          cmd = map.cmd('BufferLineCycleNext'),
          desc = 'go to one buffer right',
        },
        {
          key = '<leader>H',
          cmd = map.cmd('BufferLineMovePrev'),
          desc = 'swap one buffer left',
        },
        {
          key = '<leader>L',
          cmd = map.cmd('BufferLineMoveNext'),
          desc = 'swap one buffer right',
        },
        {
          key = '<leader>d',
          cmd = map.cmd('Bdelete'),
          desc = 'close current buffer',
        },
        {
          key = '<leader>dh',
          cmd = map.cmd('BufferLineCloseLeft'),
          desc = 'close all buffers to the left',
        },
        {
          key = '<leader>dl',
          cmd = map.cmd('BufferLineCloseRight'),
          desc = 'close all buffers to the right',
        },
        {
          key = '<leader>dd',
          cmd = map.cmd('BufferLineCloseLeft', 'BufferLineCloseRight'),
          desc = 'close all buffers except current',
        },
        {
          key = '<leader>da',
          cmd = map.cmd(
            'BufferLineCloseLeft',
            'BufferLineCloseRight',
            'Bdelete'
          ),
          desc = 'close all buffers',
        },
      })
      require('bufferline').setup(opts)
    end,
  },
  { 'tiagovla/scope.nvim' },
}
