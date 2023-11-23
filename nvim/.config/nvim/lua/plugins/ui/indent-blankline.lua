return {
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      scope = {
        enabled = false,
      },
      exclude = {
        filetypes = { 'dashboard' },
      },
    },
  },
  {
    'echasnovski/mini.indentscope',
    version = '*',
    opts = { try_as_border = true },
    config = function(opts)
      vim.api.nvim_create_autocmd({ 'Filetype' }, {
        pattern = 'dashboard',
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
      require('mini.indentscope').setup(opts)
    end,
  },
}
