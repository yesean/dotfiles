local util = require('lspconfig/util')
local lsp_installer = require('nvim-lsp-installer')
local maps = require('maps')

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
  turn_off_formatting(client)
  require('navigator.lspclient.mapping').setup({
    client = client,
    bufnr = bfr,
    cap = capabilities,
  })
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
      maps.bn(bfr, 'gi', ':TSLspImportAll<cr>')
      maps.bn(bfr, 'go', ':TSLspOrganize<cr>')

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

local build_keymaps = function()
  local keymaps = {
    { 'gr', "require('navigator.reference').async_ref()" },
    { '<m-k>', 'signature_help()', mode = 'i' },
    { '<c-k>', 'signature_help()' },
    { 'g0', "require('navigator.symbols').document_symbols()" },
    { 'gW', "require('navigator.workspace').workspace_symbol()" },
    { '<c-]>', "require('navigator.definition').definition()" },
    { 'gd', "require('navigator.definition').definition()" },
    { 'gD', "declaration({ border = 'rounded', max_width = 80 })" },
    { 'gt', 'type_definition()' },
    { 'gp', "require('navigator.definition').definition_preview()" },
    { 'K', 'hover({ popup_opts = { border = single, max_width = 80 }})' },
    {
      '<leader>a',
      "require('navigator.codeAction').code_action()",
      mode = 'n',
    },
    { '<leader>A', 'range_code_action()', mode = 'v' },
    { '<leader>rn', "require('navigator.rename').rename()" },
    { 'gi', 'implementation()' },
    { '<leader>e', "require('navigator.diagnostics').show_diagnostics()" },
    { 'gG', "require('navigator.diagnostics').show_buf_diagnostics()" },
    { 'gGG', "require('navigator.diagnostics').toggle_diagnostics()" },
    { ']d', "diagnostic.goto_next({ border = 'rounded', max_width = 80})" },
    { '[d', "diagnostic.goto_prev({ border = 'rounded', max_width = 80})" },
    { ']O', 'diagnostic.set_loclist()' },
    { ']r', "require('navigator.treesitter').goto_next_usage()" },
    { '[r', "require('navigator.treesitter').goto_previous_usage()" },
    { '<leader>wa', "require('navigator.workspace').add_workspace_folder()" },
    {
      '<leader>wr',
      "require('navigator.workspace').remove_workspace_folder()",
    },
    { '<Space>ff', 'formatting()', mode = 'n' },
    { '<Space>ff', 'range_formatting()', mode = 'v' },
    {
      '<Space>wl',
      "require('navigator.workspace').list_workspace_folders()",
    },
    { '<Space>la', "require('navigator.codelens').run_action()", mode = 'n' },
  }
  local navigator_keymaps = {}
  for _, v in ipairs(keymaps) do
    local keymap = { key = v[1], func = v[2] }
    if v.mode then
      keymap.mode = v.mode
    end
    table.insert(navigator_keymaps, keymap)
  end
  return navigator_keymaps
end

vim.diag = vim.diagnostic
require('navigator').setup({
  lsp_installer = true,
  lsp = {
    format_on_save = false,
    disable_format_cap = {},
  },
  default_mapping = false,
  keymaps = build_keymaps(),
})
