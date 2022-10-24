local null_ls = require('null-ls')
local map = require('mapping')

local fmt = null_ls.builtins.formatting
local diag = null_ls.builtins.diagnostics
local sources = {
  diag.luacheck.with({ extra_args = { '--globals', 'vim', 'use' } }), -- lua
  fmt.stylua,
  fmt.prettierd,
  fmt.rustfmt,
  fmt.yapf,
  fmt.isort,
  fmt.goimports,
  fmt.gofmt,
  fmt.golines,
  fmt.clang_format,
  fmt.shfmt.with({ extra_args = { '-i', '2', '-ci' } }),
  fmt.sql_formatter,
  fmt.nginx_beautifier,
  fmt.trim_newlines,
  fmt.trim_whitespace,
  fmt.shellharden,
  fmt.latexindent,

  diag.pylint,
  diag.shellcheck,
  diag.hadolint,
  diag.chktex,
  diag.markdownlint.with({
    extra_args = { '--config', '/home/sean/.markdownlint.json' },
  }),
  diag.write_good.with({
    extra_args = { '--no-passive', '--no-adverb', '--no-tooWordy' },
  }),
}

local group = vim.api.nvim_create_augroup('LspFormatting', {})
local function format(buffer)
  vim.lsp.buf.format({
    bufnr = buffer,
    filter = function(formatter)
      return formatter.name == 'null-ls'
    end,
    timeout_ms = 4000,
  })
end

null_ls.setup({
  sources = sources,
  on_attach = function(client, buffer)
    if client.supports_method('textDocument/formatting') then
      vim.api.nvim_clear_autocmds({
        event = 'BufWritePre',
        buffer = buffer,
        group = group,
      })
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = buffer,
        desc = 'Format on save with null-ls: '
          .. vim.api.nvim_buf_get_name(buffer),
        group = group,
        callback = function()
          format(buffer)
        end,
      })
      map.n('<leader>f', function()
        format(buffer)
      end, { desc = 'format document' })
    end
  end,
})
