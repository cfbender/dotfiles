local actions = require("diffview.actions")
require("diffview").setup({
	view = {
		merge_tool = {
			layout = "diff3_mixed",
		},
	},
	keymaps = {
		view = {
			["<leader>co"] = false,
			["<leader>ct"] = false,
			["<leader>cb"] = false,
			["<leader>ca"] = false,
			["<leader>mo"] = actions.conflict_choose("ours"), -- Choose the OURS version of a conflict
			["<leader>mt"] = actions.conflict_choose("theirs"), -- Choose the THEIRS version of a conflict
			["<leader>mb"] = actions.conflict_choose("base"), -- Choose the BASE version of a conflict
			["<leader>ma"] = actions.conflict_choose("all"), -- Choose all the versions of a conflict
		},
	},
})
