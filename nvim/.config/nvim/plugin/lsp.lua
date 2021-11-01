local util = require('lspconfig/util')
local lsp_installer = require('nvim-lsp-installer')
local maps = require('maps')

-- define keymaps when lsp client attaches
local on_attach = function(format)
  return function(client, bfr)
    local lc = function(cmd, prefix)
      prefix = prefix or 'lua'
      return '<cmd>' .. prefix .. ' ' .. cmd .. '<cr>'
    end
    maps.bn(bfr, 'gd', lc('lsp_definitions', 'Telescope'))
    maps.bn(bfr, 'gr', lc('lsp_references', 'Telescope'))
    maps.bn(bfr, 'gt', lc('vim.lsp.buf.type_definition()'))
    maps.bn(bfr, 'gD', lc('vim.lsp.buf.declaration()'))
    maps.bn(bfr, 'gi', lc('vim.lsp.buf.implementation()'))
    maps.bn(bfr, 'K', lc('vim.lsp.buf.hover()'))
    maps.bn(bfr, '<C-k>', lc('vim.lsp.buf.signature_help()'))
    maps.bn(bfr, '<space>rn', lc('vim.lsp.buf.rename()'))
    maps.bn(bfr, '<space>a', lc('vim.lsp.buf.code_action()'))
    maps.bn(bfr, '<space>e', lc('vim.lsp.diagnostic.show_line_diagnostics()'))
    maps.bn(bfr, '[d', lc('vim.lsp.diagnostic.goto_prev()'))
    maps.bn(bfr, ']d', lc('vim.lsp.diagnostic.goto_next()'))
    maps.bn(bfr, '<space>ql', lc('vim.lsp.diagnostic.set_loclist()'))
    maps.bn(bfr, '<space>f', lc('vim.lsp.buf.formatting()'))

    -- use null-ls formatter or turn it off
    if format then
      vim.cmd('autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()')
    else
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
    end
  end
end

-- add additional capabilities supported by nvim-cmp
local capabilities = require('cmp_nvim_lsp').update_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

-- setup language servers
lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = on_attach(false),
    capabilities = capabilities,
  }

  -- language specific options --
  if server.name == 'tsserver' then
    -- modify typescript lsp setup to allow curr dir as project root
    opts.root_dir = util.root_pattern(
      'package.json',
      'tsconfig.json',
      '.git',
      vim.loop.cwd()
    )
  elseif server.name == 'stylelint_lsp' then
    -- only start stylelint in css-related files, exclude react files
    opts.filetypes = { 'css', 'less', 'scss' }
  elseif server.name == 'sumneko_lua' then
    -- inject globals into lua for neovim config
    opts.settings = {
      Lua = { diagnostics = { globals = { 'vim', 'use' } } },
    }
  end

  server:setup(opts)
  vim.cmd([[ do User LspAttachBuffers ]])
end)
require('lspconfig').r_language_server.setup({ on_attach = on_attach(false) })
require('lspconfig')['null-ls'].setup({ on_attach = on_attach(true) })
