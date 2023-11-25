local sources = {
  servers = {
    'astro-language-server',
    'bash-language-server',
    'clangd',
    'cmake-language-server',
    'css-lsp',
    'dockerfile-language-server',
    'eslint-lsp',
    'gopls',
    'graphql-language-service-cli',
    'html-lsp',
    'jdtls',
    'json-lsp',
    'marksman',
    'pyright',
    'rust-analyzer',
    'sqlls',
    'stylelint-lsp',
    'lua-language-server',
    'tailwindcss-language-server',
    'texlab',
    'typescript-language-server',
    'yaml-language-server',
  },
  linters = {
    'cmakelang',
    'cmakelint',
    'cpplint',
    'hadolint',
    'luacheck',
    'markdownlint',
    'pylint',
    'shellcheck',
    'write-good',
  },
  formatters = {
    'clang-format',
    'goimports',
    'golines',
    'isort',
    'prettier',
    'shellharden',
    'shfmt',
    'sql-formatter',
    'stylua',
    'yapf',
  },
}

local utils = require('utils')
return utils.merge_lists(sources.servers, sources.linters, sources.formatters)
