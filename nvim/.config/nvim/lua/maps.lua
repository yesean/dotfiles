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
local nmap = modemap('n')
local imap = modemap('i')
local vmap = modemap('v')
local smap = modemap('s')

-- map leader to space
nmap('<space>', '')
vim.g.mapleader = ' '

-- pane switching
nmap('<leader>h', ':wincmd h<cr>')
nmap('<leader>j', ':wincmd j<cr>')
nmap('<leader>k', ':wincmd k<cr>')
nmap('<leader>l', ':wincmd l<cr>')

-- clipboard operations
-- Copy to clipboard
vmap('<leader>y', '"+y')
nmap('<leader>y', '"+y')
nmap('<leader>yg_', '"+yg_')
nmap('<leader>yy', '"+yy')

-- Paste from clipboard
vmap('<leader>p', '"+p')
vmap('<leader>P', '"+P')
nmap('<leader>p', '"+p')
nmap('<leader>P', '"+P')

-- make 'Y' like 'C' and 'D'
nmap('Y', 'yg_')

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
nmap('k', '(v:count > 5 ? "m\'" . v:count : "") . "k"', { expr = true })
nmap('j', '(v:count > 5 ? "m\'" . v:count : "") . "j"', { expr = true })

return {
  n = nmap,
  i = imap,
  v = vmap,
  s = smap,
}
