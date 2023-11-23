return {
  clangd = {
    cmd = {
      'clangd',
      '--clang-tidy',
    },
    capabilities = {
      offsetEncoding = {
        'utf-16',
      },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        completion = { callSnippet = 'Replace' },
        diagnostics = { globals = { 'vim' } }, -- inject globals into lua for neovim usage
      },
    },
  },
  stylelint_lsp = {
    filetypes = { 'css', 'less', 'scss' },
  },
  tsserver = {
    root_dir = function(fname)
      local project_root =
        require('lspconfig.server_configurations.tsserver').default_config.root_dir(
          fname
        )
      return project_root or vim.fn.getcwd()
    end,
  },
}
