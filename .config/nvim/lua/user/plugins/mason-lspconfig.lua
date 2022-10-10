-- use mason-lspconfig to configure LSP installations
return { -- overrides `require("mason-lspconfig").setup(...)`
	automatic_installation = true,
	ensure_installed = { "tsserver", "elixir-ls", "rust_analyzer", "sumneko_lua", "yamlls" },
}
