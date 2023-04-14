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

local mappings = {}

return { opts = opts, mappings = mappings }
