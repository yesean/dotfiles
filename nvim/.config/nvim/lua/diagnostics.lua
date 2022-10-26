local map = require('mapping')
local diagnostic = vim.diagnostic

-- configure diagnostics ui
diagnostic.config({
  float = {
    format = function(d) -- add diagnostic source to message
      if d.symbol or d.code then -- if possible, add diagnostic identifier ('no-param-reassign' in eslint, 'missing-function-docstring' in pylint)
        return string.format(
          '%s [%s, %s]',
          d.message,
          d.source,
          d.symbol or d.code
        )
      else
        return string.format('%s [%s]', d.message, d.source)
      end
    end,
  },
})

local mappings = {
  { 'ge', diagnostic.open_float, 'show floating diagnostics' },
  { '[d', diagnostic.goto_prev, 'go to previous diagnostic' },
  { ']d', diagnostic.goto_next, 'go to next diagnostic' },
  {
    'gG',
    function()
      require('telescope.builtin').diagnostics({ bufnr = 0 })
    end,
    'show buffer diagnostics',
  },
}
map.set(mappings)
