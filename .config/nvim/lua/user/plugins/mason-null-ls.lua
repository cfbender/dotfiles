-- use mason-null-ls to configure DAP/Formatters/Linter installation
return { -- overrides `require("mason-tool-installer").setup(...)`
	ensure_installed = { "prettierd", "eslint_d", "stylua", "eslint-lsp" },
}
