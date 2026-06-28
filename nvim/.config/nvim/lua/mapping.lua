local default_opts = { silent = true }
local function set_mode(mode)
  return function(keymap, command, opts)
    opts = vim.tbl_extend('force', default_opts, opts or {})
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

function M.cmd(...)
  return table.concat(vim.tbl_map(function(c)
    return '<cmd>' .. c .. '<cr>'
  end, type(...) == 'table' and ... or { ... }))
end

-- Each mapping is { key, command, named_opts... } where any named field
-- (desc, expr, buffer, ...) is forwarded directly to vim.keymap.set.
-- Shared opts: mode = 'n'|'v'|..., buffer = bufnr
function M.set(mappings, opts)
  opts = opts or {}
  local set = opts['mode'] ~= nil and M[opts['mode']] or M.n
  for _, m in ipairs(mappings) do
    local keymap_opts = vim.tbl_extend('force', {}, m)
    keymap_opts[1] = nil
    keymap_opts[2] = nil
    if opts['buffer'] then keymap_opts.buffer = opts['buffer'] end
    set(m[1], m[2], keymap_opts)
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
    desc = 'save and source file',
  },
})

-- window switching
M.set({
  { '<leader>h', M.cmd('wincmd h'), desc = 'move to the window left of current' },
  { '<leader>j', M.cmd('wincmd j'), desc = 'move to the window below current' },
  { '<leader>k', M.cmd('wincmd k'), desc = 'move to the window above current' },
  { '<leader>l', M.cmd('wincmd l'), desc = 'move to the window right of current' },
})

-- copy to clipboard
M.set(
  { { '<leader>y', '"+y', desc = 'copy selection to system clipboard' } },
  { mode = 'v' }
)
M.set({
  { '<leader>y',  '"+y',   desc = 'copy to system clipboard' },
  { '<leader>Y',  '"+yg_', desc = 'copy until end of line to system clipboard' },
  { '<leader>yy', '"+yy',  desc = 'copy line to system clipboard' },
})

-- paste from clipboard
M.set({
  { '<leader>p', '"+p', desc = 'paste below line from system clipboard' },
  { '<leader>P', '"+P', desc = 'paste above line from system clipboard' },
}, { mode = 'v' })
M.set({
  { '<leader>p', '"+p', desc = 'paste below line from system clipboard' },
  { '<leader>P', '"+P', desc = 'paste above line from system clipboard' },
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
