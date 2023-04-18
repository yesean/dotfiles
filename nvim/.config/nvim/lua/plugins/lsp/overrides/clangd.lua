local opts = {
  cmd = {
    'clangd',
    '--clang-tidy',
  },
  capabilities = {
    offsetEncoding = {
      'utf-16',
    },
  },
}

local mappings = {}

return { opts = opts, mappings = mappings }
