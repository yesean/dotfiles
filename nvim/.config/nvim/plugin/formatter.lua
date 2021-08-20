require('formatter').setup({
  logging = false,
  filetype = {
    javascript = {
      function()
        return {
          exe = 'prettier',
          args = { '--stdin-filepath', vim.api.nvim_buf_get_name(0) },
          stdin = true
        }
      end
    },
    lua = {
      function()
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
    },
    sh = {
      function()
        return { exe = 'shfmt', args = { '-i', 2 }, stdin = true }
      end
    }
  }
})

-- format on save
vim.api.nvim_exec([[
  augroup FormatAutogroup
    autocmd!
    autocmd BufWritePost *.js,*.lua,*.sh FormatWrite
  augroup END
]], true)

-- remove trailing whitespace
vim.api.nvim_exec([[
  augroup TrimTrailingWhiteSpace
      au!
      au BufWritePre * %s/\s\+$//e
      au BufWritePre * %s/\n\+\%$//e
  augroup END
]], true)
