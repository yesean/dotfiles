vim.api.nvim_create_augroup('LatexCompile', {})
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  command = 'AsyncRun pdflatex -shell-escape %; rm -rf %:t:r.{aux,log,out} indent.log _minted-%:t:r', -- compile pdf, delete misc files
  group = 'LatexCompile',
})
