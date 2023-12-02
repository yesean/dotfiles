return {
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        ['html'] = { 'prettier' },
        ['json'] = { 'prettier' },
        ['jsonc'] = { 'prettier' },
        ['markdown'] = { 'prettier' },
        ['javascript'] = { 'prettier' },
        ['javascriptreact'] = { 'prettier' },
        ['typescript'] = { 'prettier' },
        ['typescriptreact'] = { 'prettier' },
        python = { 'yapf', 'isort' },
        rust = { 'rustfmt' },
        go = { 'gofmt', 'goimports', 'golines' },
        c = { 'clang_format' },
        cpp = { 'clang_format' },
        sh = { 'shfmt', 'shellharden' },
        sql = { 'pg_format' },
        ['_'] = { 'trim_whitespace' },
      },
      formatters = {
        shfmt = { prepend_args = { '--indent', 2 } },
      },
      format_on_save = {
        lsp_fallback = true,
        timeout_ms = 1000,
      },
    },
  },
}
