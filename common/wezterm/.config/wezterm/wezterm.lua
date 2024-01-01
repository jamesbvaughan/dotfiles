local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Font
config.font = wezterm.font 'Berkeley Mono'
config.font_size = 16

-- Tab bar
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- Window
-- config.window_background_opacity = 0.8
-- config.macos_window_background_blur = 40
config.window_padding = {
  left = '1px',
  right = '1px',
  top = '1px',
  bottom = '1px',
}

-- Colors
--- Set up a version of gruvbox with a pure black background
local color_schemes = wezterm.color.get_builtin_schemes()
local gruvbox_dark_extra_hard = color_schemes['GruvboxDarkHard']
gruvbox_dark_extra_hard.background = '#000'
gruvbox_dark_extra_hard.tab_bar = { background = '#000' }
config.color_schemes = { ['GruvboxDarkExtraHard'] = gruvbox_dark_extra_hard }

--- Set the colorschemes
local dark_mode_theme = 'GruvboxDarkExtraHard'
local light_mode_theme = 'Gruvbox Light'

--- Follow the system dark/light mode
local dark_mode = wezterm.gui.get_appearance():find 'Dark'
config.color_scheme = dark_mode and dark_mode_theme or light_mode_theme

return config
