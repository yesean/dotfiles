require('options')
require('mapping')
require('diagnostics')
if require('utils').is_vscode then
  require('vscode-config')
end

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
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

require('lazy').setup('plugins')

vim.filetype.add({
  pattern = {
    ['Dockerfile.*'] = 'dockerfile',
  },
})
