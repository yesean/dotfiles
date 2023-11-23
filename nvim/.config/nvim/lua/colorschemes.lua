local colorschemes = {
  catppuccin = {
    'catppuccin/nvim',
    lazy = false,
    priority = 1000,
    opts = { flavour = 'macchiato' },
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme('catppuccin')
    end,
  },
  tokyonight = {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
    config = function(_, opts)
      require('tokyonight').setup(opts)
      vim.cmd.colorscheme('tokyonight')
    end,
  },
}

local selected_colorscheme_name = 'tokyonight'

return {
  selected_colorscheme_name = selected_colorscheme_name,
  selected_colorscheme = colorschemes[selected_colorscheme_name],
}
