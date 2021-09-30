vim.cmd([[autocmd BufWritePost * silent !pdflatex %]])

-- set default ft as tex
local g = vim.g
g.tex_flavor = 'latex'
