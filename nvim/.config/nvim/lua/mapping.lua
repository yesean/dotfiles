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

local map = {
  n = set_mode('n'),
  i = set_mode('i'),
  v = set_mode('v'),
  s = set_mode('s'),
  cmd = cmd,
}

-- map leader to space
map.n('<space>', '')
vim.g.mapleader = ' '

-- pane switching
map.n('<leader>h', cmd('wincmd h'))
map.n('<leader>j', cmd('wincmd j'))
map.n('<leader>k', cmd('wincmd k'))
map.n('<leader>l', cmd('wincmd l'))

-- copy to clipboard
map.v('<leader>y', '"+y')
map.n('<leader>y', '"+y')
map.n('<leader>Y', '"+yg_')
map.n('<leader>yy', '"+yy')

-- paste from clipboard
map.v('<leader>p', '"+p')
map.v('<leader>P', '"+P')
map.n('<leader>p', '"+p')
map.n('<leader>P', '"+P')

-- keep center cursor
map.n('n', 'nzz')
map.n('N', 'Nzz')

-- add punctuation to undo break points
map.i(',', ',<c-g>u')
map.i('.', '.<c-g>u')
map.i('!', '!<c-g>u')
map.i('?', '?<c-g>u')
map.i('[', '[<c-g>u')

-- add relative moves to jumplist
map.n('k', add_jumplist('k'), { expr = true })
map.n('j', add_jumplist('j'), { expr = true })

return map
