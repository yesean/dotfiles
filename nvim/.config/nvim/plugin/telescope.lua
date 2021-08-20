local grep_command = {
  'rg',
  '--hidden',
  '--color=never',
  '--no-heading',
  '--with-filename',
  '--line-number',
  '--column',
  '--smart-case'
}

require('telescope').setup({ defaults = { vimgrep_arguments = grep_command } })

-- telescope key bindings
local map = vim.api.nvim_set_keymap
local opts = { noremap = true }

local find_command =
    [[{ 'fd', '--hidden', '--follow', '--exclude', '{.git,node_modules}' }]]

map('n', '<c-p>',
    [[<cmd>lua require('telescope.builtin').find_files({ find_command = ]] ..
        find_command .. [[})<cr>]], opts)
map('n', '<c-f>', [[<cmd>lua require('telescope.builtin').live_grep({})<cr>]],
    opts)
map('n', '<leader>fb', '<cmd>lua require(\'telescope.builtin\').buffers()<cr>',
    opts)
map('n', '<leader>fh',
    '<cmd>lua require(\'telescope.builtin\').help_tags()<cr>', opts)
