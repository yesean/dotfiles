local map = require('mapping')
local vscode = require('vscode')

-- VSCode shortcuts
local mappings = {
  {
    key = 'gr',
    cmd = function()
      vscode.action('editor.action.referenceSearch.trigger')
    end,
  },
  {
    key = '<leader>r',
    cmd = function()
      vscode.action('editor.action.rename')
    end,
  },
}
map.set(mappings)
