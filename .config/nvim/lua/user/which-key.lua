-- Modify which-key registration (Use this with mappings table in mappings.lua)
return {
	-- Add bindings which show up as group name
	register = {
		-- first key is the mode, n == normal mode
		n = {
			-- second key is the prefix, <leader> prefixes
			["<leader>"] = {
				-- third key is the key to bring up next level and its displayed
				-- group name in which-key top level menu
				["b"] = { name = "Buffer" },
			},
			["<leader><space>"] = { name = "Hop" },
			["<leader>m"] = {
				name = "Diffview choose operations",
				-- third key is the key to bring up next level and its displayed
				-- group name in which-key top level menu
				o = "Choose the OURS version of a conflict",
				t = "Choose the THEIRS version of a conflict",
				b = "Choose the BASE version of a conflict",
				a = "Choose all the versions of a conflict",
			},
			["[x"] = "Diffview previous conflict",
			["]x"] = "Diffview next conflict",
		},
	},
}
