local language_servers = require('plugins.lsp.sources.language-servers')
local formatters = require('plugins.lsp.sources.formatters')
local linters = require('plugins.lsp.sources.linters')
local sources = vim.list_extend(vim.list_extend(language_servers, formatters), linters)

return {
  'WhoIsSethDaniel/mason-tool-installer.nvim',
  dependencies = {
    { 'williamboman/mason.nvim', build = ':MasonUpdate', config = true },
  },
  opts = {
    ensure_installed = sources,
  },
}
