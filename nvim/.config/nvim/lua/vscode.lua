local map = require('mapping')

-- VSCode shortcuts
local mappings = {
  {
    'gr',
    map.cmd("call VSCodeNotify('editor.action.referenceSearch.trigger')"),
  },
  {
    '<leader>r',
    map.cmd("call VSCodeNotify('editor.action.rename')"),
  },
}
map.set(mappings)
