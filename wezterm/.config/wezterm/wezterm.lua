local wezterm = require 'wezterm'
local config = {}

config.font = wezterm.font 'Berkeley Mono'
-- config.font = wezterm.font 'Monaspace Argon'
config.font_size = 16

config.hide_tab_bar_if_only_one_tab = true

config.window_background_opacity = 0.8
config.macos_window_background_blur = 40

local function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

local function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'flexoki-dark'
  else
    return 'flexoki-light'
  end
end

config.color_scheme = scheme_for_appearance(get_appearance())

return config
