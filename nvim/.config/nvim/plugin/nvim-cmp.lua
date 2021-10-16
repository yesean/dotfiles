local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  mapping = {
    ['<cr>'] = cmp.mapping.confirm({ select = true }),
    ['<c-f>'] = cmp.mapping.scroll_docs(4),
    ['<c-d>'] = cmp.mapping.scroll_docs(-4),
    ['<c-e>'] = cmp.mapping.close(),
    ['<tab>'] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, {
      'i',
      's',
    }),
    ['<s-tab>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {
      'i',
      's',
    }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  formatting = {
    format = require('lspkind').cmp_format({
      with_text = true,
      menu = {
        nvim_lsp = '[LSP]',
        luasnip = '[LuaSnip]',
        path = '[Path]',
        buffer = '[Buffer]',
        nvim_lua = '[Lua]',
      },
    }),
  },
})
