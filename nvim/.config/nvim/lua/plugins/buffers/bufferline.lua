return {
  {
    'akinsho/bufferline.nvim',
    dependencies = {
      'catppuccin/nvim',
    },
    opts = function()
      return {
        options = {
          show_close_icon = false,
          hover = {
            enabled = true,
            reveal = { 'close' },
          },
          indicator = {
            style = 'underline',
          },
          offsets = {
            {
              filetype = 'neo-tree',
              text = 'File Explorer',
              text_align = 'center',
            },
          },
          highlights = require('catppuccin.groups.integrations.bufferline').get(),
        },
      }
    end,
    config = function(_, opts)
      local map = require('mapping')
      map.set({
        { '<c-h>', map.cmd('BufferLineCyclePrev'), 'go to one buffer left' },
        { '<c-l>', map.cmd('BufferLineCycleNext'), 'go to one buffer right' },
        { '<leader>H', map.cmd('BufferLineMovePrev'), 'swap one buffer left' },
        { '<leader>L', map.cmd('BufferLineMoveNext'), 'swap one buffer right' },
        {
          '<leader>d',
          function()
            require('bufdelete').bufwipeout()
          end,
          'close current buffer',
        },
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
          '<leader>da',
          function()
            local bufs = vim.api.nvim_list_bufs()
            require('bufdelete').bufwipeout({ bufs[1], bufs[#bufs] })
          end,
          'close all buffers',
        },
        {
          '<leader>dd',
          map.cmd('BufferLineCloseLeft', 'BufferLineCloseRight'),
          'close all buffers except current',
        },
      })
      require('bufferline').setup(opts)
    end,
  },
}
