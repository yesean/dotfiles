require('trouble').setup({})

local map = vim.api.nvim_set_keymap
local opts = { silent = true, noremap = true }
map('n', '<leader>xx', '<cmd>TroubleToggle<cr>', opts)
