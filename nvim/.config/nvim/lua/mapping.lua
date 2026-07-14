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

-- Each mapping is { key = keymap, cmd = command, desc = '...', ... }
-- where any extra named field is forwarded to vim.keymap.set.
-- Shared opts: mode = 'n'|'v'|..., buffer = bufnr
function M.set(mappings, opts)
  opts = opts or {}
  local set = opts.mode ~= nil and M[opts.mode] or M.n
  for _, m in ipairs(mappings) do
    local keymap_opts = vim.tbl_extend('force', {}, m)
    keymap_opts.key = nil
    keymap_opts.cmd = nil
    if opts.buffer then
      keymap_opts.buffer = opts.buffer
    end
    set(m.key, m.cmd, keymap_opts)
  end
end

-- map leader to space
M.n('<space>', '')
vim.g.mapleader = ' '

-- saving / reloading
M.set({
  {
    key = '<leader>w',
    cmd = function()
      vim.cmd.w()
      vim.cmd.so('%')
    end,
    desc = 'save and source file',
  },
})

-- window switching
M.set({
  {
    key = '<leader>h',
    cmd = M.cmd('wincmd h'),
    desc = 'move to the window left of current',
  },
  {
    key = '<leader>j',
    cmd = M.cmd('wincmd j'),
    desc = 'move to the window below current',
  },
  {
    key = '<leader>k',
    cmd = M.cmd('wincmd k'),
    desc = 'move to the window above current',
  },
  {
    key = '<leader>l',
    cmd = M.cmd('wincmd l'),
    desc = 'move to the window right of current',
  },
})

-- copy to clipboard
M.set({
  {
    key = '<leader>y',
    cmd = '"+y',
    desc = 'copy selection to system clipboard',
  },
}, { mode = 'v' })
M.set({
  { key = '<leader>y', cmd = '"+y', desc = 'copy to system clipboard' },
  {
    key = '<leader>Y',
    cmd = '"+yg_',
    desc = 'copy until end of line to system clipboard',
  },
  { key = '<leader>yy', cmd = '"+yy', desc = 'copy line to system clipboard' },
})

-- paste from clipboard
M.set({
  {
    key = '<leader>p',
    cmd = '"+p',
    desc = 'paste below line from system clipboard',
  },
  {
    key = '<leader>P',
    cmd = '"+P',
    desc = 'paste above line from system clipboard',
  },
}, { mode = 'v' })
M.set({
  {
    key = '<leader>p',
    cmd = '"+p',
    desc = 'paste below line from system clipboard',
  },
  {
    key = '<leader>P',
    cmd = '"+P',
    desc = 'paste above line from system clipboard',
  },
})

-- when pasting, place deleted text in the _ register instead of the default one
-- this way, pastes don't override yanked content
M.x('p', '"_dP', { desc = 'paste without overwriting yank register' })

-- add punctuation to undo break points
M.i(',', ',<c-g>u', { desc = 'insert comma with undo break point' })
M.i('.', '.<c-g>u', { desc = 'insert period with undo break point' })
M.i('!', '!<c-g>u', { desc = 'insert exclamation mark with undo break point' })
M.i('?', '?<c-g>u', { desc = 'insert question mark with undo break point' })
M.i('[', '[<c-g>u', { desc = 'insert bracket with undo break point' })

-- add "significant" relative moves to jumplist, center cursor afterwards
local function add_to_jumplist(key)
  return function()
    local motion = vim.v.count > 3 and "m'" .. vim.v.count .. key or key
    return motion
  end
end
M.n('k', add_to_jumplist('k'), { expr = true, desc = 'move up, adding to jumplist if count > 3' })
M.n('j', add_to_jumplist('j'), { expr = true, desc = 'move down, adding to jumplist if count > 3' })

return M
