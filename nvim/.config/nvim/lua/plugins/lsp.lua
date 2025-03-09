local sources = require('lsp.sources')
local map = require('mapping')
local utils = require('utils')

local function merge(tbl_a, tbl_b)
  -- if either/both tables are null, return the other or empty table
  if not tbl_a or not tbl_b then
    return tbl_a or tbl_b or {}
  end

  vim.tbl_deep_extend('error', tbl_a, tbl_b)
end

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
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'folke/trouble.nvim' },
    },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      -- trouble.open factory function
      local tt = function(cmd)
        return function()
          require('trouble').open(cmd)
        end
      end
      local lsp = vim.lsp.buf

      -- lsp mappings
      local default_mappings = {
        {
          'gd',
          function()
            if vim.fn.exists(':TSToolsGoToSourceDefinition') ~= 0 then
              vim.cmd.TSToolsGoToSourceDefinition()
            else
              tt('lsp_definitions')()
            end
          end,
          'go to definition',
        },
        { 'gr', tt('lsp_references'), 'go to references' },
        { 'gy', tt('lsp_type_definitions'), 'go to type definition' },
        { 'gi', tt('lsp_implementations'), 'go to implementation' },
        { 'ga', map.cmd('CodeActionMenu'), 'select code actions' },

        { 'K', lsp.hover, 'display hover information' },
        { '<c-k>', lsp.signature_help, 'display signature information' },
        { '<leader>r', lsp.rename, 'rename symbol' },
      }

      -- add additional capabilities supported by nvim-cmp
      local default_capabilities = vim.tbl_deep_extend(
        'force',
        require('cmp_nvim_lsp').default_capabilities(),
        {
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true,
            },
          },
        }
      )

      -- suggested fix for stale diagnostics: https://www.reddit.com/r/neovim/comments/mm1h0t/comment/huic9px/?utm_source=reddit&utm_medium=web2x&context=3
      local default_flags = {
        allow_incremental_sync = false,
        debounce_text_changes = 500,
      }

      local default_opts = {
        default_capabilities,
        default_flags,
      }

      -- setup language servers
      local overrides = require('lsp.overrides')
      for _, server in
        ipairs(require('mason-lspconfig').get_installed_servers())
      do
        local override_opts = overrides[server] or {}

        -- merge default opts with overrides
        local opts = vim.tbl_deep_extend('force', default_opts, override_opts)

        -- append override.on_attach callback
        opts.on_attach = function(client, bufnr)
          map.set(default_mappings)
          if override_opts.on_attach then
            override_opts.on_attach(client, bufnr)
          end
        end

        -- use setup fn from typescript.nvim
        if server == 'tsserver' then
          require('typescript-tools').setup({ server = opts })
        else
          require('lspconfig')[server].setup(opts)
        end
      end
    end,
  },
  { 'onsails/lspkind-nvim' },
}
