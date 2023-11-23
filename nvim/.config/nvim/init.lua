require('options')
require('mapping')
require('diagnostics')
if vim.g.vscode then
  require('vscode')
end
require('vscode')

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  { import = 'plugins.autocomplete' },
  { import = 'plugins.buffers' },
  { import = 'plugins.editing' },
  { import = 'plugins.git' },
  { import = 'plugins.language-support' },
  { import = 'plugins.lsp' },
  { import = 'plugins.session' },
  { import = 'plugins.snippets' },
  { import = 'plugins.syntax' },
  { import = 'plugins.terminal' },
  { import = 'plugins.colorscheme' },
  { import = 'plugins.ui' },
  { import = 'plugins.telescope' },
}, {
  change_detection = {
    notify = false,
  },
})

vim.filetype.add({
  pattern = {
    ['Dockerfile.*'] = 'dockerfile',
  },
})
