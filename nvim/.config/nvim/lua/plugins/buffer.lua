return {
  { 'famiu/bufdelete.nvim' },
  {
    'akinsho/bufferline.nvim',
    dependencies = { 'catppuccin/nvim' },
    opts = function()
      return {
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
          -- highlights = require('catppuccin.groups.integrations.bufferline').get(),
        },
      }
    end,
    config = function(_, opts)
      local map = require('mapping')
      map.set({
        { '<c-y>', map.cmd('BufferLinePick'), 'select a buffer by key' },
        { '<c-h>', map.cmd('BufferLineCyclePrev'), 'go to one buffer left' },
        { '<c-l>', map.cmd('BufferLineCycleNext'), 'go to one buffer right' },
        { '<leader>H', map.cmd('BufferLineMovePrev'), 'swap one buffer left' },
        { '<leader>L', map.cmd('BufferLineMoveNext'), 'swap one buffer right' },
        { '<leader>d', map.cmd('Bdelete'), 'close current buffer' },
        {
          '<leader>dh',
          map.cmd('BufferLineCloseLeft'),
          'close all buffers to the left',
        },
        {
          '<leader>dl',
          map.cmd('BufferLineCloseRight'),
          'close all buffers to the right',
        },
        {
          '<leader>dd',
          map.cmd('BufferLineCloseLeft', 'BufferLineCloseRight'),
          'close all buffers except current',
        },
        {
          '<leader>da',
          map.cmd('BufferLineCloseLeft', 'BufferLineCloseRight', 'Bdelete'),
          'close all buffers',
        },
      })
      require('bufferline').setup(opts)
    end,
  },
  { 'tiagovla/scope.nvim' },
}
