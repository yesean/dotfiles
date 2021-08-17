local actions = require('telescope.actions')
require('telescope').setup()

-- telescope key bindings
vim.api.nvim_set_keymap('n', '<c-p>',
                        "<cmd>lua require('telescope.builtin').find_files({ find_command = { 'fd', '--hidden', '--follow', '--exclude' ,'{.git,node_modules,games}' } })<cr>",
                        {noremap = true})
vim.api.nvim_set_keymap('n', '<c-f>',
                        "<cmd>lua require('telescope.builtin').live_grep()<cr>",
                        {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fb',
                        "<cmd>lua require('telescope.builtin').buffers()<cr>",
                        {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fh',
                        "<cmd>lua require('telescope.builtin').help_tags()<cr>",
                        {noremap = true})
