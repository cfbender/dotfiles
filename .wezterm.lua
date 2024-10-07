local wezterm = require("wezterm")

local config = wezterm.config_builder()
local theme = wezterm.plugin.require("https://github.com/neapsix/wezterm").main

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "Catppuccin Frappe"
config.font = wezterm.font_with_fallback({
	"0xProto Nerd Font",
	"monospace",
})
config.font_size = 14.0
config.colors.theme.colors()
config.window_frame.theme.window_frame()

-- and finally, return the configuration to wezterm
return config
