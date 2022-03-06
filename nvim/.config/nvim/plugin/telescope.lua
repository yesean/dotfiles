local maps = require('maps')
local trouble = require('trouble.providers.telescope')

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
    mappings = {
      i = { ['<c-t>'] = trouble.open_with_trouble },
      n = { ['<c-t>'] = trouble.open_with_trouble },
    },
  },
})
require('telescope').load_extension('fzf')
