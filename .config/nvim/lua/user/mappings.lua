local utils = require("astronvim.utils")
-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
local maps = {
	-- first key is the mode
	n = {
		-- second key is the lefthand side of the map
		-- hop.nvim
		["<leader><space>"] = { name = "Hop" },
		["<leader><leader>w"] = { "<cmd>HopWord<cr>", desc = "Hop to a word" },
		["<leader><leader>p"] = { "<cmd>HopPattern<cr>", desc = "Hop to a pattern" },
		["<leader>bt"] = { "<cmd>BufferLineSortByTabs<cr>", desc = "Sort by tabs" },
		["<leader>gj"] = {
			function()
				require("gitsigns").next_hunk()
			end,
			desc = "Next Git hunk",
		},
		["<leader>gk"] = {
			function()
				require("gitsigns").prev_hunk()
			end,
			desc = "Previous Git hunk",
		},
		["<leader>ff"] = { "<cmd>Telescope git_files<cr>", desc = "Search all files in git" },
		["<leader>fr"] = { "<cmd>Telescope resume<cr>", desc = "Resume previous telescope search" },
		["<leader>lg"] = { "<cmd>Neogen<cr>", desc = "Generate annotation for the current node" },
		-- neotest
		["<leader>n"] = { name = " Neotest", desc = " Neotest" },
		["<leader>nn"] = {
			function()
				require("neotest").run.run()
			end,
			desc = "Run the nearest test",
		},
		["<leader>nd"] = {
			function()
				require("neotest").run.run({ strategy = "dap" })
			end,
			desc = "Debug the nearest test",
		},
		["<leader>ns"] = {
			function()
				require("neotest").summary.toggle()
			end,
			desc = "Toggle test summary",
		},
		["<leader>nf"] = {
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "Run tests for the current file",
		},
		-- coverage
		["<leader>lc"] = {
			"<cmd>Copilot panel<cr>",
			desc = "Open copilot panel",
		},
		-- coverage
		["<leader>lv"] = {
			function()
				require("coverage").toggle()
			end,
			desc = "Toggle coverage info",
		},
		-- resize with arrows
		["<Up>"] = {
			function()
				require("smart-splits").resize_up(2)
			end,
			desc = "Resize split up",
		},
		["<Down>"] = {
			function()
				require("smart-splits").resize_down(2)
			end,
			desc = "Resize split down",
		},
		["<Left>"] = {
			function()
				require("smart-splits").resize_left(2)
			end,
			desc = "Resize split left",
		},
		["<Right>"] = {
			function()
				require("smart-splits").resize_right(2)
			end,
			desc = "Resize split right",
		},
		[","] = {
			"@@",
			desc = "Replay last used macro",
		},
		["<leader>b"] = { name = "Buffer" },
		L = {
			function()
				require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1)
			end,
			desc = "Next buffer",
		},
		H = {
			function()
				require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1))
			end,
			desc = "Previous buffer",
		},
		["<leader>c"] = {
			function()
				local bufs = vim.fn.getbufinfo({ buflisted = true })
				require("astronvim.utils.buffer").close()
				if require("astronvim.utils").is_available("alpha-nvim") and not bufs[2] then
					require("alpha").start(true)
				end
			end,
			desc = "Close buffer",
		},
	},
	t = {
		["<c-q>"] = { "<c-\\><c-n>", desc = "Terminal normal mode" },
		["<esc><esc>"] = { "<c-\\><c-n>:q<cr>", desc = "Terminal quit" },
	},
}

if vim.fn.executable("iex") == 1 then
	maps.n["<leader>te"] = {
		function()
			utils.toggle_term_cmd("iex")
		end,
		desc = "ToggleTerm iex",
	}
end

if vim.fn.executable("gobang") == 1 then
	maps.n["<leader>tb"] = {
		function()
			utils.toggle_term_cmd("gobang")
		end,
		desc = "ToggleTerm gobang",
	}
end

if vim.fn.executable("lazydocker") == 1 then
	maps.n["<leader>td"] = {
		function()
			utils.toggle_term_cmd("lazydocker")
		end,
		desc = "ToggleTerm lazydocker",
	}
end

return maps
