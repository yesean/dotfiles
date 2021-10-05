local lspconfig = require('lspconfig')
local util = require('lspconfig/util')
local lspinstall = require('lspinstall')
local coq = require('coq')

-- general on_attach function
-- define keybindings
local on_attach = function(client, bufnr)
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

-- typescript on_attach function (adds nvim-lsp-ts-utils integration)
local function on_attach_ts(client, bufnr)
  -- disable tsserver formatting if you plan on formatting via null-ls
  client.resolved_capabilities.document_formatting = false
  client.resolved_capabilities.document_range_formatting = false

  local ts_utils = require('nvim-lsp-ts-utils')

  -- defaults
  ts_utils.setup({
    debug = false,
    disable_commands = false,
    enable_import_on_completion = false,

    -- import all
    import_all_timeout = 5000, -- ms
    import_all_priorities = {
      buffers = 4, -- loaded buffer names
      buffer_content = 3, -- loaded buffer content
      local_files = 2, -- git files or files with relative path markers
      same_file = 1, -- add to existing import statement
    },
    import_all_scan_buffers = 100,
    import_all_select_source = false,

    -- eslint
    eslint_enable_code_actions = true,
    eslint_enable_disable_comments = true,
    eslint_bin = 'eslint',
    eslint_enable_diagnostics = false,
    eslint_opts = {},

    -- formatting
    enable_formatting = false,
    formatter = 'prettier',
    formatter_opts = {},

    -- update imports on file move
    update_imports_on_move = false,
    require_confirmation_on_move = false,
    watch_dir = nil,

    -- filter diagnostics
    filter_out_diagnostics_by_severity = {},
    filter_out_diagnostics_by_code = {},
  })

  -- required to fix code action ranges and filter diagnostics
  ts_utils.setup_client(client)

  -- no default maps, so you may want to define some here
  local opts = { silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gs', ':TSLspOrganize<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'grf', ':TSLspRenameFile<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gI', ':TSLspImportAll<CR>', opts)
end

-- setup lsp clients
local function setup_servers()
  lspinstall.setup()
  local servers = lspinstall.installed_servers()
  for _, server in ipairs(servers) do
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = { 'documentation', 'detail', 'additionalTextEdits' },
    }

    local config = {
      on_attach = on_attach,
      flags = { debounce_text_changes = 150 },
      capabilities = capabilities,
    }

    -- modify typescript lsp setup to allow curr dir as project root
    if server == 'typescript' then
      config.root_dir = util.root_pattern(
        'package.json',
        'tsconfig.json',
        '.git',
        vim.loop.cwd()
      )
      config.on_attach = on_attach_ts
    end

    -- inject globals into lua for neovim
    if server == 'lua' then
      config.settings = {
        Lua = { diagnostics = { globals = { 'vim', 'use' } } },
      }
    end

    lspconfig[server].setup(coq.lsp_ensure_capabilities(config))
  end
  require('lspconfig').r_language_server.setup(coq.lsp_ensure_capabilities({}))
end

setup_servers()
