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

return { opts = opts }
