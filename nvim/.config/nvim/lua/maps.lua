local map = vim.api.nvim_set_keymap

map('n', '<space>', '', {})
vim.g.mapleader = ' '

opts = { noremap = true }
map('n', '<leader>h', ':wincmd h<cr>', opts)
map('n', '<leader>j', ':wincmd j<cr>', opts)
map('n', '<leader>k', ':wincmd k<cr>', opts)
map('n', '<leader>l', ':wincmd l<cr>', opts)
