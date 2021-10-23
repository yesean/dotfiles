local util = require('lspconfig/util')
local lsp_installer = require('nvim-lsp-installer')
local maps = require('maps')

-- general on_attach function
-- define keybindings
local function on_attach(client, bufnr)
  local opts = { noremap = true, silent = true }
  local function map(key, action)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', key, action, opts)
  end
  map('gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
  map('gd', '<cmd>Telescope lsp_definitions<cr>')
  map('gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
  map('gr', '<cmd>Telescope lsp_references<cr>')
  map('K', '<cmd>lua vim.lsp.buf.hover()<cr>')
  map('<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
  map('<space>D', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
  map('<space>rn', '<cmd>lua vim.lsp.buf.rename()<cr>')
  map('<space>a', '<cmd>lua vim.lsp.buf.code_action()<cr>')
  map('<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>')
  map('[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>')
  map(']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>')
  map('<space>ql', '<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>')
  map('<space>f', '<cmd>lua vim.lsp.buf.formatting()<cr>')

  client.resolved_capabilities.document_formatting = false
  client.resolved_capabilities.document_range_formatting = false
end

-- add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- setup language servers
lsp_installer.on_server_ready(function(server)
  local opts = {
    capabilities = capabilities,
    on_attach = on_attach,
  }

  if server.name == 'tsserver' then
    -- modify typescript lsp setup to allow curr dir as project root
    opts.root_dir = util.root_pattern(
      'package.json',
      'tsconfig.json',
      '.git',
      vim.loop.cwd()
    )
  end

  if server.name == 'stylelint_lsp' then
    -- only start stylelint in *css files
    opts.filetypes = { 'css', 'less', 'scss' }
  end

  if server.name == 'sumneko_lua' then
    -- inject globals into lua for neovim
    opts.settings = {
      Lua = { diagnostics = { globals = { 'vim', 'use' } } },
    }
  end

  server:setup(opts)
  vim.cmd([[ do User LspAttachBuffers ]])
end)
require('lspconfig').r_language_server.setup({})
