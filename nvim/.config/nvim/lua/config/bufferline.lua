local map = require('mapping')

map.n('bh', map.cmd('BufferLineCyclePrev'))
map.n('bl', map.cmd('BufferLineCycleNext'))
map.n('bH', map.cmd('BufferLineMovePrev'))
map.n('bL', map.cmd('BufferLineMoveNext'))
map.n('bm', function()
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
