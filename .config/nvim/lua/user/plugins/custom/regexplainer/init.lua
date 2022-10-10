return {
	config = function()
		require("user.plugins.custom.regexplainer.config")
	end,
	requires = {
		"nvim-treesitter/nvim-treesitter",
		"MunifTanjim/nui.nvim",
	},
}
