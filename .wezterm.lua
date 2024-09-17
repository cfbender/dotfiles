local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "Catppuccin Frappe"
config.font = wezterm.font_with_fallback({
	"0xProto Nerd Font",
	"monospace",
})
config.font_size = 14.0

-- and finally, return the configuration to wezterm
return config
