local map = vim.api.nvim_set_keymap
opts = { noremap = true }

-- map leader to space
map('n', '<space>', '', {})
vim.g.mapleader = ' '

-- pane switching
map('n', '<leader>h', ':wincmd h<cr>', opts)
map('n', '<leader>j', ':wincmd j<cr>', opts)
map('n', '<leader>k', ':wincmd k<cr>', opts)
map('n', '<leader>l', ':wincmd l<cr>', opts)

-- clipboard operations
-- Copy to clipboard
map('v', '<leader>y', '"+y', opts)
map('n', '<leader>y', '"+y', opts)
map('n', '<leader>yg_', '"+yg_', opts)
map('n', '<leader>yy', '"+yy', opts)

-- Paste from clipboard
map('v', '<leader>p', '"+y', opts)
map('v', '<leader>P', '"+Y', opts)
map('n', '<leader>p', '"+y', opts)
map('n', '<leader>P', '"+Y', opts)
