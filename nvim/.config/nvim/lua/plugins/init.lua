local utils = require('utils')

local plugins = utils.merge_lists(
  { require('plugins.colorscheme.colorscheme').selected_colorscheme },
  require('plugins.autocomplete'),
  require('plugins.buffer'),
  require('plugins.editing'),
  require('plugins.language-support'),
  require('plugins.session'),
  require('plugins.snippets'),
  require('plugins.syntax'),
  require('plugins.telescope'),
  require('plugins.terminal'),
  require('plugins.ui')
)

return plugins
