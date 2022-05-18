local map = require('mapping')
local installer = require('nvim-lsp-installer')
local config = require('lspconfig')

local function add_default_maps(bfr)
  local tel = require('telescope.builtin')
  local lsp = vim.lsp.buf
  local diag = vim.diagnostic
  local opts = { buffer = bfr }

  map.n('gD', lsp.declaration, opts)
  map.n('K', lsp.hover, opts)
  map.n('<c-k>', lsp.signature_help, opts)
  map.n('<leader>r', lsp.rename, opts)
  map.n('<leader>f', lsp.formatting, opts)

  map.n('gd', tel.lsp_definitions, opts)
  map.n('gr', tel.lsp_references, opts)
  map.n('gt', tel.lsp_type_definitions, opts)
  map.n('gi', tel.lsp_implementations, opts)
  map.n('g0', tel.lsp_document_symbols, opts)
  map.n('g-', tel.treesitter, opts)
  map.n('ga', vim.lsp.buf.code_action, opts)
  map.n('gG', function()
    tel.diagnostics({ bufnr = 0 })
  end, opts)

  map.n('ge', diag.open_float, opts)
  map.n('[d', diag.goto_prev, opts)
  map.n(']d', diag.goto_next, opts)
end

local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
local function turn_off_formatting(client, bufnr)
  if client.supports_method('textDocument/formatting') then
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({
          filter = function(clients)
            return vim.tbl_filter(function(c)
              local servers = {
                'tsserver',
                'sumneko_lua',
                'gopls',
                'pyright',
              }
              return vim.tbl_contains(servers, c.name)
            end, clients)
          end,
          bufnr = bufnr,
        })
      end,
    })
  end
end

-- define keymaps when lsp client attaches
local function on_attach_default(client, bufnr)
  add_default_maps(bufnr)
  turn_off_formatting(client, bufnr)
end

-- add additional capabilities supported by nvim-cmp
local capabilities = require('cmp_nvim_lsp').update_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

-- setup language servers
installer.setup()
for _, server in ipairs(installer.get_installed_servers()) do
  local opts = {
    on_attach = on_attach_default,
    capabilities = capabilities,
  }

  -------------------------------
  -- language specific options --
  -------------------------------

  if server.name == 'tsserver' then
    -- modify typescript lsp setup to allow curr dir as project root
    opts.root_dir = function(fname)
      return require('lspconfig.server_configurations.tsserver').default_config.root_dir(
        fname
      ) or vim.fn.getcwd()
    end

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

  config[server.name].setup(opts)
end
