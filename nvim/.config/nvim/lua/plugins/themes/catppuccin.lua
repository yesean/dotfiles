return {
  {
    'catppuccin/nvim',
    lazy = false,
    priority = 1000,
    opts = { flavour = 'mocha', integrations = { neotree = true } },
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme('catppuccin')
    end,
  },
}
