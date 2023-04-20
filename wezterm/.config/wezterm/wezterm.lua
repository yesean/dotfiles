local wezterm = require('wezterm')

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'Catppuccin Mocha'
config.font_size = 11

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

return config
