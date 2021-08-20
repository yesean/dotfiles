-- nvim-lspconfig key bindings and attach them to the lsp
local on_attach = function(_, bufnr)
  local function map(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local opts = { noremap = true, silent = true }
  map('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  map('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  map('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  map('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  map('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  map('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  map('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  map('n', '<space>e',
      '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  map('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  map('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  map('n', '<space>ql', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  map('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  map('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  map('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',
      opts)
  map('n', '<space>wl',
      '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
      opts)
end

-- attach mappings to lsp once client attaches
local nvim_lsp = require('lspconfig')
local util = require('lspconfig/util')
local lspinstall = require('lspinstall')

local function setup_servers()
  lspinstall.setup()
  local servers = lspinstall.installed_servers()
  for _, server in ipairs(servers) do
    local config = {
      on_attach = on_attach,
      flags = { debounce_text_changes = 150 }
    }

    -- modify typescript lsp setup to allow curr dir as project root
    if server == 'typescript' then
      config.root_dir = util.root_pattern('package.json', 'tsconfig.json',
                                          '.git', vim.loop.cwd())
    end

    -- inject globals into lua for neovim
    if server == 'lua' then
      config.settings =
          { Lua = { diagnostics = { globals = { 'vim', 'use' } } } }
    end

    nvim_lsp[server].setup(config)
  end
end

setup_servers()
