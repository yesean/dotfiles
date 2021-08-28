local prettier = function()
  return {
    exe = 'prettier',
    args = { '--stdin-filepath', vim.api.nvim_buf_get_name(0) },
    stdin = true
  }
end

local luaFormat = function()
  return {
    exe = 'lua-format',
    args = {
      '--indent-width',
      2,
      '--column-limit',
      80,
      '--spaces-inside-table-braces',
      '--double-quote-to-single-quote',
      '--align-args',
      '--align-parameter',
      '--chop-down-table',
      '--break-after-table-lb',
      '--no-keep-simple-function-one-line'
    },
    stdin = true
  }
end

local shfmt = function()
  return { exe = 'shfmt', args = { '-i', 2 }, stdin = true }
end

local yapf = { exe = 'yapf', args = { '--style', 'google' }, stdin = true }

require('formatter').setup({
  logging = false,
  filetype = {
    json = { prettier },
    javascript = { prettier },
    javascriptreact = { prettier },
    typescript = { prettier },
    typescriptreact = { prettier },
    lua = { luaFormat },
    sh = { shfmt },
    python = { yapf }
  }
})

-- format on save
vim.api.nvim_exec([[
  augroup FormatAutogroup
    autocmd!
    autocmd BufWritePost * FormatWrite
  augroup END
]], true)

-- remove trailing whitespace
require('formatter.util').print = function()
end
vim.api.nvim_exec([[
  augroup TrimTrailingWhiteSpace
      au!
      au BufWritePre * %s/\s\+$//e
      au BufWritePre * %s/\n\+\%$//e
  augroup END
]], true)
