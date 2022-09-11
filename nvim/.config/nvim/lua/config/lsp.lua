local map = require('mapping')
local installer = require('nvim-lsp-installer')
local config = require('lspconfig')

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

local function add_default_maps(bfr)
  local tel = require('telescope.builtin')
  local lsp = vim.lsp.buf
  local diag = vim.diagnostic
  local opts = function(desc, expr)
    expr = expr or false
    return { buffer = bfr, desc = desc, expr = expr }
  end

  -- add lsp mappings
  map.n('gD', lsp.declaration, opts('go to declaration'))
  map.n('K', lsp.hover, opts('display hover information'))
  map.n('<c-k>', lsp.signature_help, opts('display signature information'))
  map.n('<leader>r', function()
    return ':IncRename ' .. vim.fn.expand('<cword>')
  end, opts('rename symbol', true))
  map.n('<leader>f', lsp.formatting, opts('format buffer'))

  -- add telescope mappings
  map.n('gd', tel.lsp_definitions, opts('go to definition'))
  map.n('gr', tel.lsp_references, opts('go to references'))
  map.n('gt', tel.lsp_type_definitions, opts('go to type definition'))
  map.n('gi', tel.lsp_implementations, opts('go to implementation'))
  map.n('g0', tel.lsp_document_symbols, opts('show lsp document symbols'))
  map.n('g-', tel.treesitter, opts('show treesitter queries'))
  map.n('ga', map.cmd('CodeActionMenu'), opts('select code actions'))
  map.n('gG', function()
    tel.diagnostics({ bufnr = 0 })
  end, opts('show buffer diagnostics'))

  -- add diagnostic mappings
  map.n('ge', diag.open_float, opts('show floating diagnostics'))
  map.n('[d', diag.goto_prev, opts('go to previous diagnostic'))
  map.n(']d', diag.goto_next, opts('go to next diagnostic'))
end

-- turn off formatting from lsp servers
local function format(bufnr)
  vim.lsp.buf.format({
    filter = function(client)
      return client.name == 'null-ls'
    end,
    bufnr = bufnr,
  })
end

local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
local function turn_off_formatting(client, bufnr)
  if client.supports_method('textDocument/formatting') then
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = augroup,
      buffer = bufnr,
      callback = function()
        format(bufnr)
      end,
    })
  end
end

-- define keymaps when lsp client attaches
local function on_attach_default(client, bufnr)
  add_default_maps(bufnr)
  turn_off_formatting(client, bufnr)
  require('nvim-navic').attach(client, bufnr)
end

-- add additional capabilities supported by nvim-cmp
local capabilities = require('cmp_nvim_lsp').update_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

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

    require('typescript').setup({ server = opts })
    return
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
