local default_opts = { silent = true }
local function set_mode(mode)
  return function(keymap, command, opts)
    opts = opts or {}
    vim.tbl_extend('force', default_opts, opts)
    vim.keymap.set(mode, keymap, command, opts)
  end
end

local M = {
  n = set_mode('n'),
  i = set_mode('i'),
  v = set_mode('v'),
  x = set_mode('x'),
  s = set_mode('s'),
}

function M.cmd(str)
  return '<cmd>' .. str .. '<cr>'
end

-- Allow a mapping to be defined as an array: {key, command, description}, useful for grouping mappings such as lsp or diagnostics.
-- Accepts an array of mappings.
function M.set(mappings, opts)
  opts = opts or {}
  for _, m in ipairs(mappings) do
    local set
    if opts['mode'] ~= nil then
      set = M[opts['mode']]
    else
      set = M.n
    end
    opts['mode'] = nil

    opts['desc'] = m[3]
    set(m[1], m[2], opts)
  end
end

-- map leader to space
M.n('<space>', '')
vim.g.mapleader = ' '

-- saving / reloading
M.set({
  {
    '<leader>w',
    function()
      vim.cmd.w()
      vim.cmd.so('%')
    end,
    'save and source file',
  },
})

-- window switching
M.set({
  { '<leader>h', M.cmd('wincmd h'), 'move to the window left of current' },
  { '<leader>j', M.cmd('wincmd j'), 'move to the window below current' },
  { '<leader>k', M.cmd('wincmd k'), 'move to the window above current' },
  { '<leader>l', M.cmd('wincmd l'), 'move to the window right of current' },
})

-- copy to clipboard
M.set(
  { { '<leader>y', '"+y', 'copy selection to system clipboard' } },
  { mode = 'v' }
)
M.set({
  { '<leader>y', '"+y', 'copy to system clipboard' },
  { '<leader>Y', '"+yg_', 'copy until end of line to system clipboard' },
  { '<leader>yy', '"+yy', 'copy line to system clipboard' },
})

-- paste from clipboard
M.set({
  { '<leader>p', '"+p', 'paste below line from system clipboard' },
  { '<leader>P', '"+P', 'paste above line from system clipboard' },
}, { mode = 'v' })
M.set({
  { '<leader>p', '"+p', 'paste below line from system clipboard' },
  { '<leader>P', '"+P', 'paste above line from system clipboard' },
})

-- when pasting, place deleted text in the _ register instead of the default one
-- this way, pastes don't override yanked content
M.x('p', '"_dP')

-- keep center cursor
M.n('n', 'nzz')
M.n('N', 'Nzz')

-- add punctuation to undo break points
M.i(',', ',<c-g>u')
M.i('.', '.<c-g>u')
M.i('!', '!<c-g>u')
M.i('?', '?<c-g>u')
M.i('[', '[<c-g>u')

-- add "significant" relative moves to jumplist, center cursor afterwards
local function add_to_jumplist(key)
  return function()
    local motion = vim.v.count > 3 and "m'" .. vim.v.count .. key or key
    return motion
  end
end
M.n('k', add_to_jumplist('k'), { expr = true })
M.n('j', add_to_jumplist('j'), { expr = true })

return M
