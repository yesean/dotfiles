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
      vim.cmd.colorscheme('tokyonight-night')
    end,
  },
  everforest = {
    'neanias/everforest-nvim',
    version = false,
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    -- Optional; default configuration will be used if setup isn't called.
    config = function()
      require('everforest').load()
    end,
  },
  ['rose-pine'] = {
    'rose-pine/neovim',
    name = 'rose-pine',
    opts = { styles = { italic = false } },
    config = function(_, opts)
      require('rose-pine').setup(opts)
      vim.cmd('colorscheme rose-pine')
    end,
  },
}

local selected_colorscheme_name = 'rose-pine'

return {
  selected_colorscheme_name = selected_colorscheme_name,
  selected_colorscheme = colorschemes[selected_colorscheme_name],
}
