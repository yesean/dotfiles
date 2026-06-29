# theme-picker.nvim

A Telescope picker for switching Neovim colorschemes with live full-editor preview. Move through the list and your entire editor — including the preview pane showing your current buffer — updates in real time. Escape to restore your original theme.

## Requirements

- Neovim >= 0.9
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

## Installation

### lazy.nvim (local)

```lua
{
  dir  = vim.fn.expand('~/path/to/theme-picker.nvim'),
  name = 'theme-picker',
  dependencies = { 'nvim-telescope/telescope.nvim' },
  config = function()
    require('theme-picker').setup({
      colorschemes = { 'rose-pine', 'rose-pine-dawn', 'rose-pine-moon' },
    })
    vim.keymap.set('n', '<leader>cs', require('theme-picker').pick, { desc = 'switch colorscheme' })
  end,
}
```

### lazy.nvim (from GitHub, after publishing)

```lua
{
  'you/theme-picker.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim' },
  config = function()
    require('theme-picker').setup({
      colorschemes = { 'rose-pine', 'catppuccin', 'tokyonight' },
    })
    vim.keymap.set('n', '<leader>cs', require('theme-picker').pick, { desc = 'switch colorscheme' })
  end,
}
```

## Setup

```lua
require('theme-picker').setup({
  -- List of colorscheme names to show in the picker.
  -- Defaults to vim.fn.getcompletion('', 'color') (all installed themes) if not set.
  colorschemes = { 'rose-pine', 'rose-pine-dawn', 'rose-pine-moon' },

  -- Telescope prompt title.
  prompt_title = 'Theme Picker',
})
```

## Usage

```lua
require('theme-picker').pick()
-- or pass per-call overrides:
require('theme-picker').pick({ prompt_title = 'Choose Theme' })
```

| Key       | Action                          |
|-----------|---------------------------------|
| `<CR>`    | Apply selected theme            |
| `<Esc>`   | Cancel and restore original     |
| Type      | Filter themes by name           |
