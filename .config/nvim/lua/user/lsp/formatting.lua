return {
	format_on_save = true,
	disabled = { "sumneko_lua", "rust_analyzer" },
	filter = function(client)
		-- only enable null-ls for some filetypes
		local null_ls_only = {
			"javascript", -- use prettierd
			"typescript", -- use prettierd
			"javascriptreact", -- use prettierd
			"typescriptreact", -- use prettierd
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
