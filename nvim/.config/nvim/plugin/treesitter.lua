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

local function resetHighlighting()
  if vim.bo.buftype == '' then
    vim.cmd('write')
    vim.cmd('edit')
    vim.cmd('TSBufEnable highlight')
  end
end

-- highlighting fix, restart treesitter when opening a new file
vim.api.nvim_create_autocmd({ 'VimEnter' }, { callback = resetHighlighting })

-- always use jsonc parser
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  pattern = '*.json',
  callback = function()
    vim.bo.filetype = 'jsonc'
    resetHighlighting()
  end,
})
