local maps = require('maps')

maps.n('<leader>q', ':BufferClose<cr>')
maps.n('<leader>qw', ':BufferCloseAllButCurrent<cr>')
maps.n('<c-l>', ':BufferNext<cr>')
maps.n('<c-h>', ':BufferPrevious<cr>')
maps.n('<leader><', ':BufferMovePrevious<cr>')
maps.n('<leader>>', ':BufferMoveNext<cr>')
maps.n('<c-y>', ':BufferPick<cr>')
