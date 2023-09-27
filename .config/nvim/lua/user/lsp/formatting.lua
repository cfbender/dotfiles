return {
	format_on_save = true,
	disabled = { "sumneko_lua", "rust_analyzer" },
	timeout_ms = 5000,
	filter = function(client)
		-- only enable null-ls for some filetypes
		local null_ls_only = {
			"javascript", -- use prettier
			"typescript", -- use prettier
			"javascriptreact", -- use prettier
			"typescriptreact", -- use prettier
			"elixir", -- use mix
			"rust", -- use rustfmt
			"lua", -- use stylua
		}
		if vim.tbl_contains(null_ls_only, vim.bo.filetype) then
			return client.name == "null-ls"
		end

		-- enable all other clients
		return true
	end,
}
