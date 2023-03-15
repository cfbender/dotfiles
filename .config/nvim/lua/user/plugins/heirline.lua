return {
	"rebelot/heirline.nvim",
	opts = function(_, opts)
		local status = require("astronvim.utils.status")
		-- local codeium_status = {
		-- 	provider = " Codeium: " .. vim.fn["codeium#GetStatusString"](),
		-- }
		opts.statusline = { -- statusline
			hl = { fg = "fg", bg = "bg" },
			status.component.mode({ mode_text = { padding = { left = 1, right = 1 } } }), -- add the mode text
			status.component.git_branch(),
			status.component.file_info({ filetype = {}, filename = false, file_modified = false }),
			status.component.git_diff(),
			status.component.diagnostics(),
			status.component.fill(),
			status.component.cmd_info(),
			status.component.fill(),
			status.component.lsp(),
			status.component.treesitter(),
			-- codeium_status,
			status.component.nav(),
			-- remove the 2nd mode indicator on the right
		}

		-- return the final configuration table
		return opts
	end,
}
