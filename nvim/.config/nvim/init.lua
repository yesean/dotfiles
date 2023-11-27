require('options')
require('mapping')
require('diagnostics')
if require('utils').is_vscode then
  require('vscode')
end

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

local colorscheme = require('colorschemes')
require('lazy').setup('plugins', {
  install = {
    colorscheme = { colorscheme.selected_colorscheme_name },
  },
})

vim.filetype.add({
  pattern = {
    ['Dockerfile.*'] = 'dockerfile',
  },
})
