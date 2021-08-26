local prettier = {
  exe = 'prettier',
  args = { '--stdin-filepath', vim.api.nvim_buf_get_name(0) },
  stdin = true
}
local luaFormat = {
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
local shfmt = { exe = 'shfmt', args = { '-i', 2 }, stdin = true }
local yapf = { exe = 'yapf', args = { '--style', 'google' }, stdin = true }

require('formatter').setup({
  logging = false,
  filetype = {
    javascript = {
      function()
        return prettier
      end
    },
    lua = {
      function()
        return luaFormat
      end
    },
    sh = {
      function()
        return shfmt
      end
    },
    python = {
      function()
        return yapf
      end
    },
    markdown = {
      function()
        return prettier
      end
    }
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
