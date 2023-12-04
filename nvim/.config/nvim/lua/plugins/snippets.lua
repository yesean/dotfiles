return {
  {
    'L3MON4D3/LuaSnip',
    dependencies = {
      'rafamadriz/friendly-snippets',
    },
    build = 'make install_jsregexp',
    opts = {
      region_check_events = 'CursorMoved',
    },
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },
}
