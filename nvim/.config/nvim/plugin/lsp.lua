local util = require('lspconfig/util')
local lsp_installer = require('nvim-lsp-installer')
local map = require('mapping')

local add_default_maps = function(bfr)
  local builtin = require('telescope.builtin')
  local opts = { buffer = bfr }
  map.n('gd', builtin.lsp_definitions, opts)
  map.n('gD', vim.lsp.buf.declaration, opts)
  map.n('gr', builtin.lsp_references, opts)
  map.n('gt', builtin.lsp_type_definitions, opts)
  map.n('gi', builtin.lsp_implementations, opts)
  map.n('gG', function()
    builtin.diagnostics({ bufnr = 0 })
  end, opts)
  map.n('g0', builtin.lsp_document_symbols, opts)
  map.n('g-', builtin.treesitter, opts)
  map.n('ga', builtin.lsp_code_actions, opts)
  map.n('K', vim.lsp.buf.hover, opts)
  map.n('<C-k>', vim.lsp.buf.signature_help, opts)
  map.n('grn', vim.lsp.buf.rename, opts)
  map.n('ge', vim.diagnostic.open_float, opts)
  map.n('[d', vim.diagnostic.goto_prev, opts)
  map.n(']d', vim.diagnostic.goto_next, opts)
  map.n('<space>f', vim.lsp.buf.formatting, opts)
end

local turn_off_formatting = function(client)
  client.resolved_capabilities.document_formatting = false
  client.resolved_capabilities.document_range_formatting = false
end

-- add additional capabilities supported by nvim-cmp
local capabilities = require('cmp_nvim_lsp').update_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

-- define keymaps when lsp client attaches
local on_attach_default = function(client, bfr)
  add_default_maps(bfr)
  turn_off_formatting(client)
end

-- setup language servers
lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = on_attach_default,
    capabilities = capabilities,
  }

  -------------------------------
  -- language specific options --
  -------------------------------

  if server.name == 'tsserver' then
    -- modify typescript lsp setup to allow curr dir as project root
    opts.root_dir = util.root_pattern(
      'package.json',
      'tsconfig.json',
      '.git',
      vim.loop.cwd()
    )

    -- inject ts-utils
    local ts_utils = require('nvim-lsp-ts-utils')
    local init_options = ts_utils.init_options
    init_options.preferences.importModuleSpecifierPreference = 'relative'
    opts.init_options = init_options
    opts.on_attach = function(client, bfr)
      on_attach_default(client, bfr)
      local map_opts = { buffer = bfr }
      map.n('gI', map.cmd('TSLspImportAll'), map_opts)
      map.n('go', map.cmd('TSLspOrganize'), map_opts)

      ts_utils.setup({
        auto_inlay_hints = false,
        filter_out_diagnostics_by_severity = { 'hint' },
        update_imports_on_move = true,
      })
      ts_utils.setup_client(client)
    end
  elseif server.name == 'stylelint_lsp' then
    -- only start stylelint in css-related files, exclude react files
    opts.filetypes = { 'css', 'less', 'scss' }
  elseif server.name == 'sumneko_lua' then
    -- inject globals into lua for neovim usage
    opts.settings = {
      Lua = {
        diagnostics = {
          globals = {
            'vim',
            'use',
          },
        },
      },
    }
  elseif server.name == 'clangd' then
    opts.capabilities.offsetEncoding = { 'utf-16' }
    opts.cmd = {
      'clangd',
      '--clang-tidy',
    }
  end

  server:setup(opts)
  vim.cmd('do User LspAttachBuffers')
end)
