local default_opts = { silent = true }
local function set_mode(mode)
  return function(keymap, command, opts)
    opts = opts or {}
    for k, v in pairs(default_opts) do
      opts[k] = v
    end
    vim.keymap.set(mode, keymap, command, opts)
  end
end

local function cmd(str)
  return '<cmd>' .. str .. '<cr>'
end

local function add_jumplist(key)
  return function()
    return vim.v.count > 3 and "m'" .. vim.v.count .. key or key
  end
end

local M = {
  n = set_mode('n'),
  i = set_mode('i'),
  v = set_mode('v'),
  s = set_mode('s'),
  cmd = cmd,
}

-- map leader to space
M.n('<space>', '')
vim.g.mapleader = ' '

-- pane switching
M.n('<leader>h', cmd('wincmd h'))
M.n('<leader>j', cmd('wincmd j'))
M.n('<leader>k', cmd('wincmd k'))
M.n('<leader>l', cmd('wincmd l'))

-- copy to clipboard
M.v('<leader>y', '"+y')
M.n('<leader>y', '"+y')
M.n('<leader>Y', '"+yg_')
M.n('<leader>yy', '"+yy')

-- paste from clipboard
M.v('<leader>p', '"+p')
M.v('<leader>P', '"+P')
M.n('<leader>p', '"+p')
M.n('<leader>P', '"+P')

-- keep center cursor
M.n('n', 'nzz')
M.n('N', 'Nzz')

-- add punctuation to undo break points
M.i(',', ',<c-g>u')
M.i('.', '.<c-g>u')
M.i('!', '!<c-g>u')
M.i('?', '?<c-g>u')
M.i('[', '[<c-g>u')

-- add relative moves to jumplist
M.n('k', add_jumplist('k'), { expr = true })
M.n('j', add_jumplist('j'), { expr = true })

-- jupyter ascending
M.n('<leader><cr>', '<Plug>JupyterExecute')

return M
