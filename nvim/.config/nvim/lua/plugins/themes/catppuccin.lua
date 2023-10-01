return {
  {
    'catppuccin/nvim',
    lazy = false,
    priority = 1000,
    opts = { flavour = 'macchiato' },
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme('catppuccin')
    end,
  },
}
