return {
	window = { position = "right" },
	filesystem = {
		filtered_items = {
			-- use H in neo-tree to un-hide hidden items if you need em
			hide_dotfiles = true,
			hide_gitignored = false,
			hide_by_name = { "node_modules", "_build", ".git", "deps" },
		},
	},
}
