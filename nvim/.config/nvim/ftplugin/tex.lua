vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  command = 'silent !pdflatex -shell-escape % && rm %:r.aux %:r.log',
})
