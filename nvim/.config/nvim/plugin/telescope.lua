local actions = require('telescope.actions')
require('telescope').setup()

-- telescope key bindings
local map = vim.api.nvim_set_keymap
local opts = {noremap = true}
map('n', '<c-p>',
    "<cmd>lua require('telescope.builtin').find_files({ find_command = { 'fd', '--hidden', '--follow', '--exclude' ,'{.git,node_modules,games}' } })<cr>",
    opts)
map('n', '<c-f>', "<cmd>lua require('telescope.builtin').live_grep()<cr>", opts)
map('n', '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<cr>",
    opts)
map('n', '<leader>fh', "<cmd>lua require('telescope.builtin').help_tags()<cr>",
    opts)
