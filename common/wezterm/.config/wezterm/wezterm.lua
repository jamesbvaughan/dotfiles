local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Font
config.font = wezterm.font("Berkeley Mono")
config.font_size = 12

-- Tab bar
config.hide_tab_bar_if_only_one_tab = true

-- Window
config.window_padding = {
	left = "0px",
	right = "0px",
	top = "0px",
	bottom = "0px",
}

-- Colors
local dark_mode_theme = "Catppuccin Mocha"
local light_mode_theme = "Catppuccin Latte"

--- Follow the system dark/light mode
local dark_mode = wezterm.gui.get_appearance():find("Dark")
config.color_scheme = dark_mode and dark_mode_theme or light_mode_theme

return config
