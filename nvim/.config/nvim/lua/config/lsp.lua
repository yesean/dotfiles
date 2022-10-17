local map = require('mapping')
local installer = require('nvim-lsp-installer')
local lspconfig = require('lspconfig')

vim.diagnostic.config({
  float = {
    format = function(diagnostic) -- add diagnostic source to message
      if diagnostic.symbol or diagnostic.code then -- if possible, add diagnostic identifier ('no-param-reassign' in eslint, 'missing-function-docstring' in pylint)
        return string.format(
          '%s [%s, %s]',
          diagnostic.message,
          diagnostic.source,
          diagnostic.symbol or diagnostic.code
        )
      else
        return string.format('%s [%s]', diagnostic.message, diagnostic.source)
      end
    end,
  },
})

local tel = require('telescope.builtin')
local lsp = vim.lsp.buf
local diag = vim.diagnostic
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
  {
    'gG',
    function()
      tel.diagnostics({ bufnr = 0 })
    end,
    'show buffer diagnostics',
  },

  -- diagnostic mappings
  { 'ge', diag.open_float, 'show floating diagnostics' },
  { '[d', diag.goto_prev, 'go to previous diagnostic' },
  { ']d', diag.goto_next, 'go to next diagnostic' },
}

-- define keymaps when lsp client attaches
local function get_on_attach(override_mappings)
  override_mappings = override_mappings or {}
  return function(client, bufnr)
    map.set_mappings(bufnr, default_mappings)
    map.set_mappings(bufnr, override_mappings)
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
installer.setup()
for _, server in ipairs(installer.get_installed_servers()) do
  local opts = {
    on_attach = get_on_attach(),
    capabilities = capabilities,
  }

  -------------------------------
  -- language specific options --
  -------------------------------

  if server.name == 'tsserver' then
    -- allow tsserver to use curr dir as project root
    opts.root_dir = function(fname)
      return require('lspconfig.server_configurations.tsserver').default_config.root_dir(
        fname
      ) or vim.fn.getcwd()
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

  if server.name == 'tsserver' then
    local ts_mappings = {
      {
        'gd',
        map.cmd('TypescriptGoToSourceDefinition'),
        'go to source definition',
      },
    }
    opts.on_attach = get_on_attach(ts_mappings)
    require('typescript').setup({ server = opts })
  else
    lspconfig[server.name].setup(opts)
  end
end
