local util = require('lspconfig/util')
local lsp_installer = require('nvim-lsp-installer')

-- general on_attach function
-- define keybindings
local function on_attach(client, bufnr)
  local opts = { noremap = true, silent = true }
  local function map(key, action)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', key, action, opts)
  end
  map('gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>')
  map('gd', '<Cmd>lua vim.lsp.buf.definition()<CR>')
  map('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  map('gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  map('K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
  map('<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  map('<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  map('<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  map('<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  map('<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
  map('[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
  map(']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
  map('<space>ql', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
  map('<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
  map('<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
  map('<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
  map(
    '<space>wl',
    '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>'
  )

  client.resolved_capabilities.document_formatting = false
  client.resolved_capabilities.document_range_formatting = false
end

-- add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- setup lsp clients
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
