function toggleTree()
  function openTree()
    require'bufferline.state'.set_offset(30, 'FileTree')
    require'nvim-tree'.find_file(true)
  end

  function closeTree()
    require'bufferline.state'.set_offset(0)
    require'nvim-tree'.close()
  end

  local view = require 'nvim-tree.view'
  if view.win_open() then
    closeTree()
  else
    openTree()
  end
end

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
map('n', '<leader>n', '<cmd>lua toggleTree()<CR>', opts)
map('n', '<leader>q', ':BufferClose<cr>', opts)
map('n', '<leader>qw', ':BufferCloseAllButCurrent<cr>', opts)
map('n', '<leader>qr', ':BufferCloseAllButPinned<cr>', opts)
map('n', '<c-l>', ':BufferNext<cr>', opts)
map('n', '<c-h>', ':BufferPrevious<cr>', opts)
map('n', '<c-[>', ':BufferMovePrevious<cr>', opts)
map('n', '<c-]>', ':BufferMoveNext<cr>', opts)
map('n', '<c-y>', ':BufferPick<cr>', opts)
