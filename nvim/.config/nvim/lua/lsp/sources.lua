local M = {}

-- Keys are lspconfig server names.
-- pkg overrides the mason package name when it differs from the lspconfig name.
-- All other fields are merged into the lsp server config.
M.servers = {
  astro = { pkg = 'astro-language-server' },
  basedpyright = {
    settings = {
      pyright = { disableOrganizeImports = true },
      python = { analysis = { ignore = { '*' } } },
    },
  },
  bashls = { pkg = 'bash-language-server' },
  clangd = {
    cmd = { 'clangd', '--clang-tidy' },
    capabilities = { offsetEncoding = { 'utf-16' } },
  },
  cmake = { pkg = 'cmake-language-server' },
  cssls = { pkg = 'css-lsp' },
  dockerls = { pkg = 'dockerfile-language-server' },
  eslint = {
    pkg = 'eslint-lsp',
    on_attach = function(_, bufnr)
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,
        command = 'EslintFixAll',
      })
    end,
  },
  gopls = {},
  graphql = { pkg = 'graphql-language-service-cli' },
  html = { pkg = 'html-lsp' },
  jdtls = {},
  jsonls = { pkg = 'json-lsp' },
  lua_ls = {
    pkg = 'lua-language-server',
    settings = {
      Lua = {
        completion = { callSnippet = 'Replace' },
        diagnostics = { globals = { 'vim' } },
      },
    },
  },
  marksman = {},
  ruff = {},
  rust_analyzer = { pkg = 'rust-analyzer' },
  sqlls = {},
  stylelint_lsp = {
    pkg = 'stylelint-lsp',
    filetypes = { 'css', 'less', 'scss' },
  },
  tailwindcss = { pkg = 'tailwindcss-language-server' },
  texlab = {},
  ts_ls = {
    pkg = 'typescript-language-server',
    root_dir = function(fname)
      local project_root =
        require('lspconfig.server_configurations.ts_ls').default_config.root_dir(
          fname
        )
      return project_root or vim.fn.getcwd()
    end,
  },
  yamlls = { pkg = 'yaml-language-server' },
}

-- Keys are Mason package names.
M.linters = {
  cmakelang = {},
  cmakelint = {},
  cpplint = {},
  luacheck = {},
  markdownlint = {},
  shellcheck = {},
  ['write-good'] = {},
}

-- Keys are conform.nvim formatter names.
-- pkg overrides the mason package name when it differs.
-- All other fields are forwarded to conform's formatters config.
M.formatters = {
  clang_format = { pkg = 'clang-format' },
  goimports = {},
  isort = {},
  pg_format = { pkg = 'pgformatter' },
  prettier = {},
  shellharden = {},
  shfmt = { prepend_args = { '--indent', 2 } },
  stylua = {},
  taplo = {},
}

-- Returns a flat list of all mason package names across servers, linters, and formatters.
function M.mason_tools()
  local tools = {}
  for lsp_name, config in pairs(M.servers) do
    table.insert(tools, config.pkg or lsp_name)
  end
  for name in pairs(M.linters) do
    table.insert(tools, name)
  end
  for conform_name, config in pairs(M.formatters) do
    table.insert(tools, config.pkg or conform_name)
  end
  return tools
end

-- Returns lsp opts for a given lspconfig server name, with pkg stripped.
function M.lsp_opts(lsp_name)
  local opts = vim.tbl_extend('force', {}, M.servers[lsp_name] or {})
  opts.pkg = nil
  return opts
end

-- Returns the conform formatters config table (non-empty entries, pkg stripped).
function M.conform_formatters()
  local result = {}
  for conform_name, config in pairs(M.formatters) do
    local opts = vim.tbl_extend('force', {}, config)
    opts.pkg = nil
    if next(opts) ~= nil then
      result[conform_name] = opts
    end
  end
  return result
end

return M
