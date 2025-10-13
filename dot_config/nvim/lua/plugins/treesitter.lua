-- Customize Treesitter

---@type LazySpec
return {
	"nvim-treesitter/nvim-treesitter",
	opts = {
		ensure_installed = {
			"css",
			"elixir",
			"fish",
			"go",
			"graphql",
			"haskell",
			"html",
			"javascript",
			"jsdoc",
			"json",
			"liquid",
			"lua",
			"markdown",
			"markdown_inline",
			"nu",
			"powershell",
			"regex",
			"rust",
			"toml",
			"tsx",
			"typescript",
			"vim",
			"yaml",
		},
	},
}
