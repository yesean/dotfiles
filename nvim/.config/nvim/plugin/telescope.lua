local maps = require('mapping')

local grep_command = {
  'rg',
  '--hidden',
  '--color=never',
  '--no-heading',
  '--with-filename',
  '--line-number',
  '--column',
  '--smart-case',
}

-- telescope key bindings
maps.n('<leader>t', '<cmd>Telescope<cr>')
local find_command =
  [[{ 'fd', '--type', 'f', '--hidden', '--follow', '--exclude', '{.git,node_modules}' }]]
maps.n(
  '<c-p>',
  [[<cmd>lua require('telescope.builtin').find_files({ find_command = ]]
    .. find_command
    .. [[})<cr>]]
)
maps.n('<c-f>', '<cmd>Telescope live_grep<cr>')

require('telescope').setup({
  defaults = {
    vimgrep_arguments = grep_command,
    layout_strategy = 'flex',
    layout_config = {
      width = 0.85,
      height = 0.85,
      vertical = {
        prompt_position = 'top',
      },
      horizontal = {
        prompt_position = 'bottom',
      },
      flex = {
        flip_columns = 220,
      },
    },
  },
})
require('telescope').load_extension('fzf')

maps.n('gk', '<cmd>Telescope keymaps<cr>')
maps.n('gm', '<cmd>Telescope git_status<cr>')
maps.n('gl', '<cmd>Telescope git_bcommits<cr>')
