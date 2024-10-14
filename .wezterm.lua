local wezterm = require("wezterm")
-- for rosepine
-- local theme = wezterm.plugin.require('https://github.com/neapsix/wezterm').main
local flavor = "Catppuccin Frappe"
local theme = wezterm.color.get_builtin_schemes()[flavor]

local config = {
	font = wezterm.font_with_fallback({
		"0xProto Nerd Font",
		{ family = "DankMono Nerd Font", weight = "Regular" },
	}),
	colors = theme,
	color_scheme = flavor,
	-- for rosepine
	-- window_frame = theme.window_frame(), -- needed only if using fancy tab bar
	default_prog = {
		"C:\\Users\\codyf\\AppData\\Local\\Microsoft\\WindowsApps\\Microsoft.PowerShell_8wekyb3d8bbwe\\pwsh.exe",
	},
	window_decorations = "RESIZE",
}

return config
