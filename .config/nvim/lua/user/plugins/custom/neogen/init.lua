return {
	config = function()
		require("user.plugins.custom.neogen.config")
	end,
	requires = "nvim-treesitter/nvim-treesitter",
	-- Uncomment next line if you want to follow only stable versions
	-- tag = "*"
}
