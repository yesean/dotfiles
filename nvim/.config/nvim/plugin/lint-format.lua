local null_ls = require('null-ls')

local fmt = null_ls.builtins.formatting
local diag = null_ls.builtins.diagnostics
local sources = {
  -- lua
  diag.luacheck.with({ extra_args = { '--globals', 'vim', 'use' } }),
  fmt.stylua,

  -- js/ts
  fmt.prettier,

  -- python
  diag.pylint,
  -- fmt.black,
  fmt.yapf,
  fmt.isort,

  -- golang
  fmt.goimports,
  fmt.gofmt,
  fmt.golines,

  -- java/c/c++
  fmt.clang_format,

  -- shell
  diag.shellcheck,
  fmt.shfmt.with({ extra_args = { '-i', '2', '-ci' } }),
  -- fmt.shellharden,

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
  local opts = { noremap = true, silent = true }
  local function nmap(key, action)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', key, action, opts)
  end
  nmap('gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  nmap('gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  nmap('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  nmap('gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  nmap('K', '<cmd>lua vim.lsp.buf.hover()<CR>')
  nmap('<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  nmap('<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  nmap('<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  nmap('<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  nmap('<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
  nmap('[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
  nmap(']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
  nmap('<space>ql', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
  nmap('<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
  nmap('<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
  nmap('<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
  nmap(
    '<space>wl',
    '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>'
  )

  -- run formatters on save
  vim.cmd('autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()')
end
require('lspconfig')['null-ls'].setup({ on_attach = on_attach })
