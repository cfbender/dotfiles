-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
	"AstroNvim/astrocommunity",
	{ import = "astrocommunity.colorscheme.catppuccin" },
	{ import = "astrocommunity.colorscheme.dracula-nvim" },
	{ import = "astrocommunity.colorscheme.kanagawa-nvim" },
	{ import = "astrocommunity.colorscheme.nord-nvim" },
	{ import = "astrocommunity.colorscheme.tokyonight-nvim" },
	{ import = "astrocommunity.completion.copilot-lua" },
	{ import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },
	{ import = "astrocommunity.git.diffview-nvim" },
	{ import = "astrocommunity.git.fugit2-nvim" },
	{ import = "astrocommunity.motion.flash-nvim" },
	{ import = "astrocommunity.motion.grapple-nvim" },
	{ import = "astrocommunity.pack.chezmoi" },
	{ import = "astrocommunity.pack.go" },
	{ import = "astrocommunity.pack.haskell" },
	{ import = "astrocommunity.pack.html-css" },
	{ import = "astrocommunity.pack.lua" },
	{ import = "astrocommunity.pack.markdown" },
	{ import = "astrocommunity.pack.python" },
	{ import = "astrocommunity.pack.rust" },
	{ import = "astrocommunity.pack.sql" },
	{ import = "astrocommunity.pack.typescript" },
	{ import = "astrocommunity.pack.yaml" },
	{ import = "astrocommunity.recipes.picker-lsp-mappings" },
	{ import = "astrocommunity.test.nvim-coverage" },
	{ import = "astrocommunity.test.vim-test" },
}
