require('luasnip.config').setup({
  region_check_events = 'CursorMoved',
})

-- load friendly-snippets
require('luasnip.loaders.from_vscode').lazy_load()
