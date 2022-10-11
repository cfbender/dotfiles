return {
	format_on_save = true,
	disabled = { "sumneko_lua", "rust_analyzer" },
	filter = function(client)
		-- only enable null-ls for some filetypes
		local null_ls_only = {
			"javascript",
			"typescript",
			"javascriptreact",
			"typescriptreact",
			"elixir",
			"rust",
			"lua",
		}
		if vim.tbl_contains(null_ls_only, vim.bo.filetype) then
			return client.name == "null-ls"
		end

		-- enable all other clients
		return true
	end,
}
