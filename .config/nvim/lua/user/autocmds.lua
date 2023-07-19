vim.api.nvim_create_autocmd("FileType", {
	desc = "Load lcov Coverage for Elixir",
	group = vim.api.nvim_create_augroup("elixir_coverage", { clear = true }),
	pattern = "elixir",
	callback = function()
		require("coverage").load_lcov()
	end,
})
