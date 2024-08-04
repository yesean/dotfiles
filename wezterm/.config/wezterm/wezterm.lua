local wezterm = require('wezterm')

local config = wezterm.config_builder()

config.color_scheme = 'Tokyo Night'
config.font_size = 11
config.font = wezterm.font('Berkeley Mono Variable')

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.check_for_updates = false

config.keys = {
  {
    key = 'h',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection('Left'),
  },
  {
    key = 'j',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection('Down'),
  },
  {
    key = 'k',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection('Up'),
  },
  {
    key = 'l',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection('Right'),
  },
}

if pcall(require, 'macos') then
  require('macos').override(config)
end

return config
