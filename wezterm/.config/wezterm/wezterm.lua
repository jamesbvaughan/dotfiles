local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Rendering
-- This will be the default in newer versions of wezterm
config.front_end = 'WebGpu'

-- Font
config.font = wezterm.font 'Berkeley Mono'
config.font_size = 16

-- Tab bar
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- Window
config.window_background_opacity = 0.8
config.macos_window_background_blur = 40

-- Colors
local gruvbox_dark_extra_hard = wezterm.color.get_builtin_schemes()['GruvboxDarkHard']
gruvbox_dark_extra_hard.background = '#000'
gruvbox_dark_extra_hard.tab_bar = { background = '#000' }
config.color_schemes = { ['GruvboxDarkExtraHard'] = gruvbox_dark_extra_hard }

local dark_mode = wezterm.gui.get_appearance():find 'Dark'
config.color_scheme = dark_mode and 'GruvboxDarkExtraHard' or 'Gruvbox Light'

return config
