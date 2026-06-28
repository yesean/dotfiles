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
    },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local default_mappings = {
        { 'ga', require('tiny-code-action').code_action, 'select code actions' },
        { '<leader>r', vim.lsp.buf.rename, 'rename symbol' },
        { 'gd', vim.lsp.buf.definition, 'go to definition' },
        { 'gr', vim.lsp.buf.references, 'go to references' },
        { 'gI', vim.lsp.buf.implementation, 'go to implementation' },
        { 'K', vim.lsp.buf.hover, 'hover documentation' },
      }

      local default_flags = {
        allow_incremental_sync = false,
        debounce_text_changes = 500,
      }

      -- merge LSP capabilities with blink.cmp
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend(
        'force',
        capabilities,
        require('blink.cmp').get_lsp_capabilities({}, false)
      )

      local overrides = require('lsp.overrides')
      for _, server in ipairs(require('mason-lspconfig').get_installed_servers()) do
        local opts = {
          capabilities = capabilities,
          flags = default_flags,
        }

        local override_opts = overrides[server] or {}
        opts = vim.tbl_deep_extend('force', opts, override_opts)

        opts.on_attach = function(client, bufnr)
          map.set(default_mappings, { buffer = bufnr })
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
