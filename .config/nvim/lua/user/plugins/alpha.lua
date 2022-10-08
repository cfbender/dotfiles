local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	return {}
end

local dashboard = require("alpha.themes.dashboard")
return function(config)
	config.layout[4] = {
		type = "group",
		val = {
			dashboard.button("f", "  Find File", ":Telescope find_files<cr>"),
			dashboard.button("e", "  New file", "<cmd>enew<cr>"),
			dashboard.button("r", "  Recent Files", ":Telescope oldfiles<cr>"),
			dashboard.button("t", "  Find Text", ":Telescope live_grep<cr>"),
			dashboard.button("s", "  Load previous session", "<cmd>SessionManager! load_last_session<cr>"),
			dashboard.button("u", "  Update Plugins", ":PackerSync<CR>"),
			dashboard.button("q", "  Quit Neovim", ":qa!<CR>"),
		},
	}

	local footer = function()
		local neovim_version = "  v"
			.. vim.version().major
			.. "."
			.. vim.version().minor
			.. "."
			.. vim.version().patch
		local astronvim_version = astronvim.updater.version(true)

		local versions = neovim_version .. "   AstroNvim " .. astronvim_version
		if packer_plugins == nil then
			return versions
		else
			local total_plugins = "   " .. #vim.tbl_keys(packer_plugins) .. " Plugins"
			return versions .. total_plugins
		end
	end

	table.insert(config.layout, { type = "padding", val = 2 })
	table.insert(
		config.layout,
		{ type = "text", val = footer(), opts = { position = "center", hl = "DashboardFooter" } }
	)

	return config
end
