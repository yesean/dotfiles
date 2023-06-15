require('options')
require('mapping')
require('diagnostics')

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
  { import = 'plugins.navigation' },
  { import = 'plugins.sessions' },
  { import = 'plugins.snippets' },
  { import = 'plugins.syntax' },
  { import = 'plugins.terminal' },
  { import = 'plugins.themes' },
  { import = 'plugins.ui' },
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
