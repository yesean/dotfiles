local util = require('lspconfig/util')
local lsp_installer = require('nvim-lsp-installer')
local maps = require('maps')

local add_default_maps = function(bfr)
  local lc = function(cmd, prefix)
    prefix = prefix or 'lua'
    return '<cmd>' .. prefix .. ' ' .. cmd .. '<cr>'
  end
  maps.bn(bfr, 'gd', lc('lsp_definitions', 'Telescope'))
  maps.bn(bfr, 'gD', lc('vim.lsp.buf.declaration()'))
  maps.bn(bfr, 'gr', lc('lsp_references', 'Telescope'))
  maps.bn(bfr, 'gt', lc('lsp_type_definitions', 'Telescope'))
  maps.bn(bfr, 'gi', lc('lsp_implementations', 'Telescope'))
  maps.bn(bfr, 'gG', lc('diagnostics bufnr=0', 'Telescope'))
  maps.bn(bfr, 'g0', lc('lsp_document_symbols', 'Telescope'))
  maps.bn(bfr, 'g-', lc('treesitter', 'Telescope'))
  maps.bn(
    bfr,
    'ga',
    lc(
      'lsp_code_actions layout_config={"prompt_position":"bottom"}',
      'Telescope'
    )
  )
  maps.bn(bfr, 'K', lc('vim.lsp.buf.hover()'))
  maps.bn(bfr, '<C-k>', lc('vim.lsp.buf.signature_help()'))
  maps.bn(bfr, '<space>rn', lc('vim.lsp.buf.rename()'))
  maps.bn(bfr, '<space>a', lc('vim.lsp.buf.code_action()'))
  maps.bn(bfr, 'ge', lc('vim.diagnostic.open_float()'))
  maps.bn(bfr, '[d', lc('vim.diagnostic.goto_prev()'))
  maps.bn(bfr, ']d', lc('vim.diagnostic.goto_next()'))
  maps.bn(bfr, '<space>f', lc('vim.lsp.buf.formatting()'))
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
      maps.bn(bfr, 'gI', ':TSLspImportAll<cr>')
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
