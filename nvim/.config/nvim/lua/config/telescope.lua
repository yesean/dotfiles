local map = require('mapping')
local telescope = require('telescope')
local builtin = require('telescope.builtin')

local find_command = {
  'fd',
  '--type',
  'f',
  '--hidden',
  '--follow',
  '--exclude',
  '{.git,node_modules}',
}

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
map.n('<leader>t', map.cmd('Telescope'))
map.n('<c-p>', builtin.find_files)
map.n('<c-f>', builtin.live_grep)
map.n('gk', builtin.keymaps)
map.n('gm', builtin.git_status)
map.n('gl', builtin.git_bcommits)

telescope.setup({
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
  pickers = {
    keymaps = {
      show_plug = false,
    },
    find_files = {
      find_command = find_command,
    },
    diagnostics = {
      bufnr = 0,
    },
    lsp_code_actions = {
      layout_config = {
        prompt_position = 'bottom',
      },
    },
  },
})
telescope.load_extension('fzf')
telescope.load_extension('ui-select')
