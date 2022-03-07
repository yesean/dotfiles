vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  command = 'silent !pdflatex % && rm %:r.aux %:r.log',
})
