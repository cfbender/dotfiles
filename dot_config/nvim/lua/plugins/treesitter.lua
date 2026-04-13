-- Customize Treesitter
-- --------------------
-- Treesitter customizations are handled with AstroCore
-- as nvim-treesitter simply provides a download utility for parsers

---@type LazySpec
return {
	"AstroNvim/astrocore",
	---@type AstroCoreOpts
	opts = {
		treesitter = {
			highlight = true, -- enable/disable treesitter based highlighting
			indent = true, -- enable/disable treesitter based indentation
			auto_install = true, -- enable/disable automatic installation of detected languages
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
				"kdl",
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
	},
}
