local colorschemes = require('colorschemes')

return {
  { 'famiu/bufdelete.nvim' },
  {
    'akinsho/bufferline.nvim',
    dependencies = { colorschemes.selected_colorscheme },
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
        { '<c-y>', map.cmd('BufferLinePick'), desc = 'select a buffer by key' },
        { '<c-h>', map.cmd('BufferLineCyclePrev'), desc = 'go to one buffer left' },
        { '<c-l>', map.cmd('BufferLineCycleNext'), desc = 'go to one buffer right' },
        { '<leader>H', map.cmd('BufferLineMovePrev'), desc = 'swap one buffer left' },
        { '<leader>L', map.cmd('BufferLineMoveNext'), desc = 'swap one buffer right' },
        { '<leader>d', map.cmd('Bdelete'), desc = 'close current buffer' },
        { '<leader>dh', map.cmd('BufferLineCloseLeft'), desc = 'close all buffers to the left' },
        { '<leader>dl', map.cmd('BufferLineCloseRight'), desc = 'close all buffers to the right' },
        { '<leader>dd', map.cmd('BufferLineCloseLeft', 'BufferLineCloseRight'), desc = 'close all buffers except current' },
        { '<leader>da', map.cmd('BufferLineCloseLeft', 'BufferLineCloseRight', 'Bdelete'), desc = 'close all buffers' },
      })
      require('bufferline').setup(opts)
    end,
  },
  { 'tiagovla/scope.nvim' },
}
