local map = require('mapping')
local vscode = require('vscode')

-- VSCode shortcuts
local mappings = {
  {
    'gr',
    function()
      vscode.action('editor.action.referenceSearch.trigger')
    end,
  },
  {
    '<leader>r',
    function()
      vscode.action('editor.action.rename')
    end,
  },
}
map.set(mappings)
