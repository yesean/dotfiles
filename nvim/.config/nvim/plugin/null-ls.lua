local null_ls = require('null-ls')

local fmt = null_ls.builtins.formatting
local diag = null_ls.builtins.diagnostics
local sources = {
  -- lua
  diag.luacheck,
  fmt.stylua,

  -- js/ts
  diag.eslint_d,
  fmt.prettier,

  -- python
  diag.pylint,
  fmt.blacfmt,
  fmt.isort,

  -- java/c/c++
  fmt.clang_format,

  -- shell
  diag.shellcheck,
  fmt.shfmt,
  fmt.shellharden,

  -- docker
  diag.hadolint,

  -- sql
  fmt.sqlformat,

  -- nginx
  fmt.nginx_beautifier,

  -- latex
  diag.chktex,

  -- markdown
  diag.markdownlint,

  -- misc
  diag.codespell,
  diag.write_good,
}

null_ls.config({ sources = sources })

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
  map(
    'n',
    '<space>e',
    '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',
    opts
  )
  map('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  map('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  map('n', '<space>ql', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  map('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  map('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  map(
    'n',
    '<space>wr',
    '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',
    opts
  )
  map(
    'n',
    '<space>wl',
    '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
    opts
  )
end
require('lspconfig')['null-ls'].setup({ on_attach = on_attach })
