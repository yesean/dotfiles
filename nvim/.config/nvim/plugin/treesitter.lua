-- enable treesitter
require('nvim-treesitter.configs').setup({
  ensure_installed = 'maintained',
  highlight = {
    enable = true,
  },
  context_commentstring = {
    enable = true,
  },
})

vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldenable = false

vim.api.nvim_create_autocmd(
  { 'VimEnter' },
  { command = 'write | edit | TSBufEnable highlight' }
)
