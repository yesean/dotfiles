return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'williamboman/mason-lspconfig.nvim', config = true },
      'nvim-telescope/telescope.nvim',
      'folke/neodev.nvim',
      'jose-elias-alvarez/typescript.nvim',
      'jose-elias-alvarez/typescript.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local map = require('mapping')
      local tel = require('telescope.builtin')
      local lsp = vim.lsp.buf

      local default_mappings = {
        -- lsp mappings
        { 'gD', lsp.declaration, 'go to declaration' },
        { 'K', lsp.hover, 'display hover information' },
        { '<c-k>', lsp.signature_help, 'display signature information' },
        { '<leader>r', lsp.rename, 'rename symbol' },

        -- telescope mappings
        { 'gd', tel.lsp_definitions, 'go to definition' },
        { 'gr', tel.lsp_references, 'go to references' },
        { 'gy', tel.lsp_type_definitions, 'go to type definition' },
        { 'gi', tel.lsp_implementations, 'go to implementation' },
        { 'g0', tel.lsp_document_symbols, 'show lsp document symbols' },
        { 'g-', tel.treesitter, 'show treesitter queries' },
        { 'ga', map.cmd('CodeActionMenu'), 'select code actions' },
      }

      -- add additional capabilities supported by nvim-cmp
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      -- setup language servers
      for _, server in ipairs(require('mason-lspconfig').get_installed_servers()) do
        local opts = {
          capabilities = capabilities,
        }
        local mappings = vim.deepcopy(default_mappings)

        -- override lsp opts, if override exists
        local exists, override = pcall(require, 'plugins.lsp.overrides.' .. server)
        if exists then
          opts = vim.tbl_deep_extend('force', opts, override.opts or {})
          mappings = vim.list_extend(mappings, override.mappings or {})
        end

        function opts.on_attach(client, bufnr)
          map.set(mappings)
          require('nvim-navic').attach(client, bufnr)
        end

        -- use setup fn from typescript.nvim
        if server == 'tsserver' then
          require('typescript').setup({ server = opts })
        else
          require('lspconfig')[server].setup(opts)
        end
      end
    end,
  },
}
