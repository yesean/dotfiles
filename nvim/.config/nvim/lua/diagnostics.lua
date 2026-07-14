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
  {
    key = 'ge',
    cmd = diagnostic.open_float,
    desc = 'show floating diagnostics',
  },
  {
    key = '<leader>e',
    cmd = function()
      diagnostic.reset()
      vim.cmd.edit()
    end,
    desc = 'refresh diagnostics',
  },
  {
    key = '[d',
    cmd = diagnostic_cmds.prev,
    desc = 'go to previous diagnostic',
  },
  { key = ']d', cmd = diagnostic_cmds.next, desc = 'go to next diagnostic' },
  {
    key = 'gG',
    cmd = map.cmd('Trouble diagnostics toggle filter.buf=0'),
    desc = 'show buffer diagnostics',
  },
}
map.set(mappings)
