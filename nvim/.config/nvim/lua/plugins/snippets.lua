return {
  {
    'L3MON4D3/LuaSnip',
    dependencies = {
      'rafamadriz/friendly-snippets',
    },
    opts = {
      region_check_events = 'CursorMoved',
    },
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },
}
