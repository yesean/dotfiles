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
  eslint = {
    on_attach = function(_, bufnr)
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,
        command = 'EslintFixAll',
      })
    end,
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
  pyright = {
    settings = {
      pyright = {
        -- Using Ruff's import organizer
        disableOrganizeImports = true,
      },
      python = {
        analysis = {
          -- Ignore all files for analysis to exclusively use Ruff for linting
          ignore = { '*' },
        },
      },
    },
  },
}
