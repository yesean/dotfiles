local map = require('mapping')

map.n('<c-h>', map.cmd('BufferLineCyclePrev'))
map.n('<c-l>', map.cmd('BufferLineCycleNext'))
map.n('<leader>H', map.cmd('BufferLineMovePrev'))
map.n('<leader>L', map.cmd('BufferLineMoveNext'))
map.n('<leader>d', function()
  require('bufdelete').bufdelete()
end)

require('bufferline').setup({
  options = {
    numbers = 'buffer_id',
    separator_style = 'slant',
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
})
