return { -- override table for require("lspconfig").yamlls.setup({...})
	settings = {
		yaml = {
			schemas = {
				["http://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
				["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
			},
		},
	},
}
