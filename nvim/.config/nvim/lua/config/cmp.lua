local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  mapping = {
    ['<c-f>'] = cmp.mapping.scroll_docs(4),
    ['<c-d>'] = cmp.mapping.scroll_docs(-4),
    ['<c-p>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      else
        cmp.complete()
      end
    end, { 'i' }),
    ['<c-n>'] = cmp.mapping.select_next_item(),
    ['<c-e>'] = cmp.mapping.close(),
    ['<cr>'] = cmp.mapping.confirm({ select = true }),
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
    { name = 'nvim_lsp', priority = 6 },
    { name = 'luasnip', priority = 5 },
    { name = 'nvim_lua', priority = 4 },
    { name = 'emoji', priority = 3 },
    { name = 'path', priority = 2 },
    { name = 'buffer', priority = 1 },
    { name = 'nvim_lsp_signature_help', priority = 0 },
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  formatting = {
    format = require('lspkind').cmp_format({
      mode = 'symbol',
      menu = {
        nvim_lsp = '[lsp]',
        luasnip = '[snip]',
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

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline({}),
  sources = {
    { name = 'cmdline' },
  },
  completion = {
    completeopt = 'menu,menuone,noinsert,noselect',
  },
})

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline({}),
  sources = cmp.config.sources({
    { name = 'nvim_lsp_document_symbol' },
  }, {
    { name = 'buffer' },
  }),
  completion = {
    completeopt = 'menu,menuone,noinsert,noselect',
  },
})
