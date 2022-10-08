return {
	-- You can disable default plugins as follows:
	-- ["goolord/alpha-nvim"] = { disable = true },
	["catppuccin/nvim"] = require("user.plugins.custom.catppuccin"),
	["phaazon/hop.nvim"] = require("user.plugins.custom.hop"),
	["sindrets/diffview.nvim"] = require("user.plugins.custom.diffview"),
	["ray-x/lsp_signature.nvim"] = require("user.plugins.custom.lsp_signature"),

	-- no config needed plugins
	{ "chaoren/vim-wordmotion" },
}
