local null_ls = require('null-ls')

local fmt = null_ls.builtins.formatting
local diag = null_ls.builtins.diagnostics
local sources = {
  diag.luacheck.with({ extra_args = { '--globals', 'vim', 'use' } }), -- lua
  fmt.stylua,
  fmt.prettier,
  fmt.rustfmt,
  fmt.yapf,
  fmt.isort,
  fmt.goimports,
  fmt.gofmt,
  fmt.golines,
  fmt.clang_format,
  fmt.shfmt.with({ extra_args = { '-i', '2', '-ci' } }),
  fmt.sqlformat,
  fmt.nginx_beautifier,
  fmt.trim_newlines,
  fmt.trim_whitespace,
  -- fmt.shellharden,

  diag.pylint,
  diag.shellcheck,
  diag.hadolint,
  diag.chktex,
  diag.markdownlint.with({
    extra_args = { '--config', '/home/sean/.markdownlint.json' },
  }),
  diag.codespell,
  diag.write_good.with({
    extra_args = { '--no-passive', '--no-adverb', '--no-tooWordy' },
  }),
}

local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
null_ls.setup({
  sources = sources,
  on_attach = function(client, bufnr)
    if client.supports_method('textDocument/formatting') then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            filter = function(clients)
              return vim.tbl_filter(function(c)
                return vim.tbl_contains({
                  'tsserver', 'sumneko_lua', 'gopls', 'pyright'
                }, c.name)
              end, clients)
            end,
            bufnr = bufnr })
        end,
      })
    end
  end,
})
