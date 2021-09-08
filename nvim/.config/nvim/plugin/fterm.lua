local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
map('n', '<leader>;', '<CMD>lua require("FTerm").toggle()<CR>', opts)
map('t', '<leader>;', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', opts)
