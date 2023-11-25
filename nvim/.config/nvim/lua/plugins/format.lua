return {
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        ['html'] = { { 'prettierd', 'prettier' } },
        ['json'] = { { 'prettierd', 'prettier' } },
        ['markdown'] = { { 'prettierd', 'prettier' } },
        ['javascript'] = { { 'prettierd', 'prettier' } },
        ['javascriptreact'] = { { 'prettierd', 'prettier' } },
        ['typescript'] = { { 'prettierd', 'prettier' } },
        ['typescriptreact'] = { { 'prettierd', 'prettier' } },
        python = { 'yapf', 'isort' },
        rust = { 'rustfmt' },
        go = { 'gofmt', 'goimports', 'golines' },
        c = { 'clang_format' },
        cpp = { 'clang_format' },
        sh = { 'shfmt', 'shellharden' },
        sql = { 'pg_format' },
        ['_'] = { 'trim_whitespace' },
      },
      format_on_save = {
        lsp_fallback = true,
        timeout_ms = 500,
      },
    },
  },
}
