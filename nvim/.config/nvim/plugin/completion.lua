local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  mapping = {
    ['<c-f>'] = cmp.mapping.scroll_docs(4),
    ['<c-d>'] = cmp.mapping.scroll_docs(-4),
    ['<c-e>'] = cmp.mapping.close(),
    -- ['<cr>'] = cmp.mapping.confirm({ select = true }),
    ['<esc>'] = cmp.mapping(function(fallback)
      cmp.mapping.abort()
      fallback()
    end),
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
    { name = 'nvim_lua' },
    { name = 'path' },
    { name = 'buffer', keyword_length = 5 },
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
        nvim_lsp = '[lsp]',
        luasnip = '[luasnip]',
        nvim_lua = '[lua]',
        path = '[path]',
        buffer = '[buffer]',
      },
    }),
  },
  experimental = {
    ghost_text = true,
  },
})

-- remap <cr> on bracket behavior
require('nvim-autopairs.completion.cmp').setup({
  map_cr = true,
  map_complete = true,
  auto_select = true,
  insert = false,
  map_char = {
    all = '(',
    tex = '{',
  },
})
