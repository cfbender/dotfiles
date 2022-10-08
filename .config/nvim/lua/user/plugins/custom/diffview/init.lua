return {
	requires = "nvim-lua/plenary.nvim",
	config = function()
		require("user.plugins.custom.diffview.config")
	end,
}
