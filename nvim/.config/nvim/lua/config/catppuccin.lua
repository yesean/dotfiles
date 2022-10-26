require('catppuccin').setup({
  flavour = 'macchiato',
  compile = {
    enabled = true,
  },
  integrations = {
    cmp = true,
    fidget = true,
    gitsigns = true,
    leap = true,
    neogit = true,
    neotree = true,
    treesitter = true,
    telescope = true,
    ts_rainbow = true,
    which_key = true,
  },
  native_lsp = {
    enabled = true,
  },
  navic = {
    enabled = true,
  },
})
vim.cmd.colorscheme('catppuccin')
