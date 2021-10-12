vim.cmd([[autocmd BufWritePost * silent !pdflatex % && rm %:r.aux %:r.log]])
