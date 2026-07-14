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
      ensure_installed = sources.mason_tools(),
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
        {
          key = 'ga',
          cmd = function() require('tiny-code-action').code_action() end,
          desc = 'select code actions',
        },
        {
          key = '<leader>r',
          cmd = vim.lsp.buf.rename,
          desc = 'rename symbol',
        },
        {
          key = 'gd',
          cmd = map.cmd('Trouble lsp_definitions toggle'),
          desc = 'go to definition',
        },
        {
          key = 'gr',
          cmd = map.cmd('Trouble lsp_references toggle'),
          desc = 'go to references',
        },
        {
          key = 'gI',
          cmd = map.cmd('Trouble lsp_implementations toggle'),
          desc = 'go to implementation',
        },
        {
          key = 'K',
          cmd = vim.lsp.buf.hover,
          desc = 'hover documentation',
        },
      }

      local default_flags = {
        allow_incremental_sync = false,
        debounce_text_changes = 500,
      }

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend(
        'force',
        capabilities,
        require('blink.cmp').get_lsp_capabilities({}, false)
      )

      for _, server in
        ipairs(require('mason-lspconfig').get_installed_servers())
      do
        local server_opts = sources.lsp_opts(server)
        local server_on_attach = server_opts.on_attach

        local opts = vim.tbl_deep_extend('force', {
          capabilities = capabilities,
          flags = default_flags,
        }, server_opts)

        opts.on_attach = function(client, bufnr)
          map.set(default_mappings, { buffer = bufnr })
          if server_on_attach then
            server_on_attach(client, bufnr)
          end
        end

        vim.lsp.config[server] = opts
        vim.lsp.enable(server)
      end
    end,
  },
}
