local null_ls = require('null-ls')

local fmt = null_ls.builtins.formatting
local diag = null_ls.builtins.diagnostics
local sources = {
  -- lua
  diag.luacheck.with({ extra_args = { '--globals', 'vim', 'use' } }),
  fmt.stylua,

  -- js/ts
  fmt.prettierd,

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
  diag.write_good.with({ extra_args = { '--no-passive' } }),
}
null_ls.config({ sources = sources })
