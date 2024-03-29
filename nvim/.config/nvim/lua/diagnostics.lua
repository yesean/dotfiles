local map = require('mapping')
local utils = require('utils')
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

-- change command depending on VSCode or nvim
local diagnostic_cmds = {
  next = utils.is_vscode and map.cmd(
    "call VSCodeNotify('editor.action.marker.next')"
  ) or diagnostic.goto_next,
  prev = utils.is_vscode and map.cmd(
    "call VSCodeNotify('editor.action.marker.prev')"
  ) or diagnostic.goto_prev,
}

local mappings = {
  { 'ge', diagnostic.open_float, 'show floating diagnostics' },
  {
    '<leader>e',
    function()
      vim.diagnostic.reset()
      vim.cmd.edit()
    end,
    'refresh diagnostics',
  },
  { '[d', diagnostic_cmds.prev, 'go to previous diagnostic' },
  { ']d', diagnostic_cmds.next, 'go to next diagnostic' },
  {
    'gG',
    function()
      require('telescope.builtin').diagnostics({ bufnr = 0 })
    end,
    'show buffer diagnostics',
  },
}
map.set(mappings)
