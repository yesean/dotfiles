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

nmap('<leader>c', ':silent !pdflatex %<cr>')

-- set default ft as tex
local g = vim.g
g.tex_flavor = 'latex'
