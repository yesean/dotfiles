local map = require('mapping')

map.n('<c-h>', map.cmd('BufferLineCyclePrev'))
map.n('<c-l>', map.cmd('BufferLineCycleNext'))
map.n('<c-[>', map.cmd('BufferLineMovePrev'))
map.n('<c-]>', map.cmd('BufferLineMoveNext'))
map.n('<c-\\>', function()
  require('bufdelete').bufdelete(0, false)
end)

require('bufferline').setup({
  options = {
    offsets = {
      {
        filetype = 'neo-tree',
        text = 'File Explorer',
        text_align = 'center',
      },
    },
  },
})
