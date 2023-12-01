local wezterm = require 'wezterm'
local config = {}

config.font = wezterm.font 'Berkeley Mono'
config.font_size = 16

config.hide_tab_bar_if_only_one_tab = true

config.window_background_opacity = 0.8
config.macos_window_background_blur = 40

config.color_scheme = wezterm.gui.get_appearance():find 'Dark'
  and 'GruvboxDarkHard'
  or 'Gruvbox Light'

return config
