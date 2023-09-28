return {
	{ "williamboman/mason.nvim", opts = { PATH = "append" } },
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			automatic_installation = true,
			ensure_installed = {
				"tsserver",
				"elixirls",
				"rust_analyzer",
				"lua_ls",
				"yamlls",
				"html",
				"hls",
			},
		},
	},
	{
		"jay-babu/mason-null-ls.nvim",
		opts = {
			ensure_installed = { "prettier", "eslint_d", "stylua", "eslint-lsp" },
			handlers = {
				prettierd = function()
					require("null-ls").register(require("null-ls").builtins.formatting.prettier.with({
						condition = function(utils)
							return utils.root_has_file("package.json")
								or utils.root_has_file(".prettierrc")
								or utils.root_has_file(".prettierrc.json")
								or utils.root_has_file(".prettierrc.js")
						end,
					}))
				end,
			},
		},
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		opts = {
			ensure_installed = { "elixir" },
			automatic_setup = true,
		},
	},
}
