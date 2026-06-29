-- Each entry has:
--   spec    lazy.nvim plugin spec (setup only — no colorscheme apply)
--   apply   function called once at startup to set the active colorscheme
--   names   all vim colorscheme names this plugin ships (used by theme-picker)
--
-- lazy = false / priority = 1000 is applied only to the selected theme.
-- All others are lazy = true and loaded on demand by the picker.
local colorschemes = {
  catppuccin = {
    spec = {
      'catppuccin/nvim',
      opts = { flavour = 'macchiato' },
      config = function(_, opts)
        require('catppuccin').setup(opts)
      end,
    },
    apply = function()
      vim.cmd.colorscheme('catppuccin')
    end,
    names = {
      'catppuccin',
      'catppuccin-latte',
      'catppuccin-frappe',
      'catppuccin-macchiato',
      'catppuccin-mocha',
    },
  },
  tokyonight = {
    spec = {
      'folke/tokyonight.nvim',
      opts = {},
      config = function(_, opts)
        require('tokyonight').setup(opts)
      end,
    },
    apply = function()
      vim.cmd.colorscheme('tokyonight-night')
    end,
    names = {
      'tokyonight',
      'tokyonight-night',
      'tokyonight-storm',
      'tokyonight-day',
      'tokyonight-moon',
    },
  },
  everforest = {
    spec = {
      'neanias/everforest-nvim',
      version = false,
    },
    apply = function()
      require('everforest').load()
    end,
    names = { 'everforest' },
  },
  ['rose-pine'] = {
    spec = {
      'rose-pine/neovim',
      name = 'rose-pine',
      opts = { variant = 'main', styles = { italic = false } },
      config = function(_, opts)
        require('rose-pine').setup(opts)
      end,
    },
    apply = function()
      vim.cmd.colorscheme('rose-pine-main')
    end,
    names = { 'rose-pine-main', 'rose-pine-dawn', 'rose-pine-moon' },
  },
  kanagawa = {
    spec = {
      'rebelot/kanagawa.nvim',
      opts = {},
      config = function(_, opts)
        require('kanagawa').setup(opts)
      end,
    },
    apply = function()
      vim.cmd.colorscheme('kanagawa-wave')
    end,
    names = { 'kanagawa-wave', 'kanagawa-dragon', 'kanagawa-lotus' },
  },
  gruvbox = {
    spec = {
      'ellisonleao/gruvbox.nvim',
      opts = {},
      config = function(_, opts)
        require('gruvbox').setup(opts)
      end,
    },
    apply = function()
      vim.cmd.colorscheme('gruvbox')
    end,
    names = { 'gruvbox' },
  },
  nightfox = {
    spec = {
      'EdenEast/nightfox.nvim',
      opts = {},
      config = function(_, opts)
        require('nightfox').setup(opts)
      end,
    },
    apply = function()
      vim.cmd.colorscheme('nightfox')
    end,
    names = {
      'nightfox',
      'dayfox',
      'dawnfox',
      'duskfox',
      'nordfox',
      'terafox',
      'carbonfox',
    },
  },
  ['gruvbox-material'] = {
    spec = {
      'sainnhe/gruvbox-material',
      config = function()
        vim.g.gruvbox_material_background = 'medium'
        vim.g.gruvbox_material_enable_italic = true
      end,
    },
    apply = function()
      vim.cmd.colorscheme('gruvbox-material')
    end,
    names = { 'gruvbox-material' },
  },
  onedarkpro = {
    spec = {
      'olimorris/onedarkpro.nvim',
      opts = {},
      config = function(_, opts)
        require('onedarkpro').setup(opts)
      end,
    },
    apply = function()
      vim.cmd.colorscheme('onedark')
    end,
    names = { 'onedark', 'onelight', 'onedark_vivid', 'onedark_dark' },
  },
  nord = {
    spec = { 'shaunsingh/nord.nvim' },
    apply = function()
      vim.cmd.colorscheme('nord')
    end,
    names = { 'nord' },
  },
  oxocarbon = {
    spec = { 'nyoom-engineering/oxocarbon.nvim' },
    apply = function()
      vim.cmd.colorscheme('oxocarbon')
    end,
    names = { 'oxocarbon' },
  },
}

local default_name = 'rose-pine'
local persist_path = vim.fn.stdpath('data') .. '/colorscheme'

local installed_names = {}
for _, theme in pairs(colorschemes) do
  vim.list_extend(installed_names, theme.names)
end

-- Find the group key that owns a given colorscheme name (e.g. 'kanagawa-wave' → 'kanagawa')
local function find_group(name)
  for key, theme in pairs(colorschemes) do
    for _, n in ipairs(theme.names) do
      if n == name then
        return key
      end
    end
  end
end

local saved = vim.fn.filereadable(persist_path) == 1
    and vim.fn.readfile(persist_path)[1]
  or nil
local selected_group = find_group(saved) or default_name
local selected_apply = saved and function()
  vim.cmd.colorscheme(saved)
end or colorschemes[default_name].apply

local map = require('mapping')
local specs = {}

for name, theme in pairs(colorschemes) do
  local spec = vim.tbl_deep_extend('force', {}, theme.spec)
  if name == selected_group then
    spec.lazy = false
    spec.priority = 1000
    local original_config = spec.config
    spec.config = function(plugin, opts)
      if original_config then
        original_config(plugin, opts)
      end
      selected_apply()
    end
  else
    spec.lazy = true
  end
  table.insert(specs, spec)
end

table.insert(specs, {
  dir = vim.fn.expand('~/.dotfiles/nvim-plugins/theme-picker.nvim'),
  name = 'theme-picker',
  dependencies = { 'nvim-telescope/telescope.nvim' },
  config = function()
    require('theme-picker').setup({
      colorschemes = installed_names,
      persist = persist_path,
    })
    map.set({
      {
        key = '<leader>cs',
        cmd = function()
          require('theme-picker').pick()
        end,
        desc = 'switch colorscheme',
      },
    })
  end,
})

return specs
