return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-emoji',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp-document-symbol',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'L3MON4D3/LuaSnip',
    },
    event = { 'InsertEnter', 'CmdlineEnter' },
    opts = function(_)
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      return {
        mapping = {
          ['<c-space>'] = cmp.mapping.complete(),
          ['<c-p>'] = cmp.mapping.select_prev_item(),
          ['<c-n>'] = cmp.mapping.select_next_item(),
          ['<esc>'] = cmp.mapping(function(default_behavior)
            cmp.abort()
            default_behavior()
          end),
          ['<tab>'] = cmp.mapping(function(default_behavior)
            if cmp.visible() then
              cmp.confirm({ select = true })
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              default_behavior()
            end
          end, { 'i', 's' }),
          ['<s-tab>'] = cmp.mapping(function(default_behavior)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              default_behavior()
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp', priority = 30 },
          { name = 'luasnip' },
          { name = 'emoji' },
          { name = 'path' },
          { name = 'buffer' },
          { name = 'nvim_lsp_signature_help' },
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
              path = '[path]',
              buffer = '[buffer]',
            },
          }),
        },
        experimental = {
          ghost_text = true,
        },
      }
    end,
    config = function(_, opts)
      local cmp = require('cmp')

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' },
        }, {
          {
            name = 'cmdline',
            option = {
              ignore_cmds = { 'Man', '!' },
            },
          },
        }),
      })

      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'nvim_lsp_document_symbol' },
        }, {
          { name = 'buffer' },
        }),
      })

      cmp.setup(opts)
    end,
  },
}
