local map = vim.api.nvim_set_keymap
local modemap = function(mode)
  return function(binding, command, extra)
    extra = extra or {}
    local opts = { noremap = true }
    for k, v in pairs(extra) do
      opts[k] = v
    end
    map(mode, binding, command, opts)
  end
end

local bmap = vim.api.nvim_buf_set_keymap
local modebmap = function(mode)
  return function(buffer, binding, command, extra)
    extra = extra or {}
    local opts = { noremap = true }
    for k, v in pairs(extra) do
      opts[k] = v
    end
    bmap(buffer, mode, binding, command, opts)
  end
end

local nmap = modemap('n')
local imap = modemap('i')
local vmap = modemap('v')
local smap = modemap('s')

local bnmap = modebmap('n')
local bimap = modebmap('i')
local bvmap = modebmap('v')
local bsmap = modebmap('s')

-- map leader to space
nmap('<space>', '')
vim.g.mapleader = ' '

-- pane switching
nmap('<leader>h', ':wincmd h<cr>')
nmap('<leader>j', ':wincmd j<cr>')
nmap('<leader>k', ':wincmd k<cr>')
nmap('<leader>l', ':wincmd l<cr>')

-- copy to clipboard
vmap('<leader>y', '"+y')
nmap('<leader>y', '"+y')
nmap('<leader>Y', '"+yg_')
nmap('<leader>yy', '"+yy')

-- paste from clipboard
vmap('<leader>p', '"+p')
vmap('<leader>P', '"+P')
nmap('<leader>p', '"+p')
nmap('<leader>P', '"+P')

-- keep center cursor
nmap('n', 'nzz')
nmap('N', 'Nzz')

-- add punctuation to undo break points
imap(',', ',<c-g>u')
imap('.', '.<c-g>u')
imap('!', '!<c-g>u')
imap('?', '?<c-g>u')
imap('[', '[<c-g>u')

-- add relative moves to jumplist
nmap('k', '(v:count > 3 ? "m\'" . v:count : "") . "k"', { expr = true })
nmap('j', '(v:count > 3 ? "m\'" . v:count : "") . "j"', { expr = true })

return {
  n = nmap,
  i = imap,
  v = vmap,
  s = smap,
  bn = bnmap,
  bi = bimap,
  bv = bvmap,
  bs = bsmap,
}
