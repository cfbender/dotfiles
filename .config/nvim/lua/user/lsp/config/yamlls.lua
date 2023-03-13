return { -- override table for require("lspconfig").yamlls.setup({...})
	settings = {
		yaml = {
			schemas = {
				["https://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
				["https://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
				["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose.*.{yml,yaml}",
				["https://json.schemastore.org/traefik-v2"] = "traefik.{yml,yaml}",
			},
		},
	},
}
