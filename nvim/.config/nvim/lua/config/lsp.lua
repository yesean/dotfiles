local map = require('mapping')
local lspconfig = require('lspconfig')
local masonlsp = require('mason-lspconfig')

masonlsp.setup({
  ensure_installed = {
    'bashls',
    'clangd',
    'cssls',
    'dockerls',
    'eslint',
    'gopls',
    'graphql',
    'html',
    'jdtls',
    'jsonls',
    'marksman',
    'pyright',
    'rust_analyzer',
    'sqls',
    'stylelint_lsp',
    'sumneko_lua',
    'tailwindcss',
    'texlab',
    'tsserver',
    'yamlls',
  },
})

local tel = require('telescope.builtin')
local lsp = vim.lsp.buf
local default_mappings = {
  -- lsp mappings
  { 'gD', lsp.declaration, 'go to declaration' },
  { 'K', lsp.hover, 'display hover information' },
  { '<c-k>', lsp.signature_help, 'display signature information' },
  { '<leader>r', lsp.rename, 'rename symbol' },

  -- telescope mappings
  { 'gd', tel.lsp_definitions, 'go to definition' },
  { 'gr', tel.lsp_references, 'go to references' },
  { 'gy', tel.lsp_type_definitions, 'go to type definition' },
  { 'gi', tel.lsp_implementations, 'go to implementation' },
  { 'g0', tel.lsp_document_symbols, 'show lsp document symbols' },
  { 'g-', tel.treesitter, 'show treesitter queries' },
  { 'ga', map.cmd('CodeActionMenu'), 'select code actions' },
}

-- define keymaps when lsp client attaches
local function get_on_attach(override_mappings)
  override_mappings = override_mappings or {}
  return function(client, bufnr)
    map.set(default_mappings, { buffer = bufnr })
    map.set(override_mappings, { buffer = bufnr })
    require('nvim-navic').attach(client, bufnr)
  end
end

-- add additional capabilities supported by nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

-- setup language servers
for _, server in ipairs(masonlsp.get_installed_servers()) do
  local opts = {
    on_attach = get_on_attach(),
    capabilities = capabilities,
  }

  -------------------------------
  -- language specific options --
  -------------------------------

  if server == 'tsserver' then
    -- allow tsserver to use curr dir as project root
    opts.root_dir = function(fname)
      return require('lspconfig.server_configurations.tsserver').default_config.root_dir(
        fname
      ) or vim.fn.getcwd()
    end
    local ts_mappings = {
      {
        'gd',
        map.cmd('TypescriptGoToSourceDefinition'),
        'go to source definition',
      },
    }
    opts.on_attach = get_on_attach(ts_mappings)
  elseif server == 'stylelint_lsp' then
    -- only start stylelint in css-related files, exclude react files
    opts.filetypes = { 'css', 'less', 'scss' }
  elseif server == 'sumneko_lua' then
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
  elseif server == 'clangd' then
    opts.capabilities.offsetEncoding = { 'utf-16' }
    opts.cmd = {
      'clangd',
      '--clang-tidy',
    }
  end

  if server == 'tsserver' then
    require('typescript').setup({ server = opts })
  else
    lspconfig[server].setup(opts)
  end
end
