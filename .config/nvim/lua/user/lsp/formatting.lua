return {
	format_on_save = true,
	disabled = { "sumneko_lua" },
	filter = function(client)
		-- only enable null-ls for js/ts
		if
			vim.bo.filetype == "javascript"
			or vim.bo.filetype == "typescript"
			or vim.bo.filetype == "javascriptreact"
			or vim.bo.filetype == "typescriptreact"
		then
			return client.name == "null-ls"
		end

		-- enable all other clients
		return true
	end,
}
