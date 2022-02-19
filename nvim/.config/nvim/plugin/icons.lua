-- lsp icons
require('lspkind').init({
  -- enables text annotations
  --
  -- default: true
  mode = true,

  -- default symbol map
  -- can be either 'default' or
  -- 'codicons' for codicon preset (requires vscode-codicons font installed)
  --
  -- default: 'default'
  preset = 'codicons',

  -- override preset symbols
  --
  -- default: {}
  symbol_map = {
    Text = '',
    Method = '',
    Function = '',
    Constructor = '',
    Field = 'ﰠ',
    Variable = '',
    Class = 'ﴯ',
    Interface = '',
    Module = '',
    Property = 'ﰠ',
    Unit = '塞',
    Value = '',
    Enum = '',
    Keyword = '',
    Snippet = '',
    Color = '',
    File = '',
    Reference = '',
    Folder = '',
    EnumMember = '',
    Constant = '',
    Struct = 'פּ',
    Event = '',
    Operator = '',
    TypeParameter = '',
  },
})

-- general icons
require('nvim-web-devicons').setup({ default = true })
