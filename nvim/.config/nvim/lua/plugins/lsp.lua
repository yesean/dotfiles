local sources = require('lsp.sources')
local map = require('mapping')
local utils = require('utils')

return {
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = {
      { 'williamboman/mason.nvim', build = ':MasonUpdate', config = true },
    },
    opts = {
      ensure_installed = sources,
    },
  },
  {
    'neovim/nvim-lspconfig',
    cond = not utils.is_vscode,
    dependencies = {
      { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
      { 'williamboman/mason-lspconfig.nvim', opts = {} },
      { 'nvim-telescope/telescope.nvim' },
      { 'folke/neodev.nvim' },
    },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lsp = vim.lsp.buf

      -- lsp mappings
      local default_mappings = {
        {
          'ga',
          require('tiny-code-action').code_action,
          'select code actions',
        },
        { 'K', lsp.hover, 'display hover information' },
        { '<c-k>', lsp.signature_help, 'display signature information' },
        { '<leader>r', lsp.rename, 'rename symbol' },
      }

      -- suggested fix for stale diagnostics: https://www.reddit.com/r/neovim/comments/mm1h0t/comment/huic9px/?utm_source=reddit&utm_medium=web2x&context=3
      local default_flags = {
        allow_incremental_sync = false,
        debounce_text_changes = 500,
      }

      -- merge LSP capabilities with blink.nvim
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend(
        'force',
        capabilities,
        require('blink.cmp').get_lsp_capabilities({}, false)
      )

      -- setup language servers
      local overrides = require('lsp.overrides')
      for _, server in
        ipairs(require('mason-lspconfig').get_installed_servers())
      do
        local opts = { capabilities, default_flags }

        -- merge default opts with overrides
        local override_opts = overrides[server] or {}
        opts = vim.tbl_deep_extend('force', opts, override_opts)

        -- append override.on_attach callback
        opts.on_attach = function(client, bufnr)
          map.set(default_mappings)
          if override_opts.on_attach then
            override_opts.on_attach(client, bufnr)
          end
        end

        vim.lsp.config[server] = opts
        vim.lsp.enable(server)
      end
    end,
  },
  { 'onsails/lspkind-nvim' },
}
