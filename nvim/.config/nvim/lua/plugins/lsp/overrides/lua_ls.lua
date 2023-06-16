local opts = {
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Replace',
      },
      diagnostics = {
        -- inject globals into lua for neovim usage
        globals = {
          'vim',
          'use',
        },
      },
    },
  },
}

return { opts = opts }
