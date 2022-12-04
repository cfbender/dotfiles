return {
	-- You can disable default plugins as follows:
	-- ["goolord/alpha-nvim"] = { disable = true },
	["catppuccin/nvim"] = { -- Soothing pastel theme for Neovim
		config = function()
			vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
			require("catppuccin").setup()
		end,
		as = "catppuccin",
	},
	["phaazon/hop.nvim"] = { -- Neovim motions on speed!
		branch = "v2", -- optional but strongly recommended,
		config = function()
			require("hop").setup()
		end,
		module = "hop",
		opt = true,
		setup = function()
			table.insert(astronvim.file_plugins, "hop.nvim")
		end,
	},
	["sindrets/diffview.nvim"] = { -- Single tabpage interface for easily cycling through diffs for all modified files for any git rev.
		opt = true,
		setup = function()
			table.insert(astronvim.git_plugins, "diffview.nvim")
		end,
		requires = "nvim-lua/plenary.nvim",
		config = function()
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
		end,
	},

	["ray-x/lsp_signature.nvim"] = { -- LSP signature hint as you type
		event = "BufRead",
		config = function()
			require("lsp_signature").setup()
		end,
	},
	["folke/neodev.nvim"] = { -- 💻 Dev setup for init.lua and plugin development with full signature help, docs and completion for the nvim lua API.
		opt = true,
		setup = function()
			table.insert(astronvim.file_plugins, "neodev.nvim")
		end,
		config = function()
			require("neodev").setup({})
		end,
	},
	["danymat/neogen"] = { -- A better annotation generator. Supports multiple languages and annotation conventions.
		opt = true,
		setup = function()
			table.insert(astronvim.file_plugins, "neogen")
		end,
		config = function()
			require("neogen").setup({})
		end,
		requires = "nvim-treesitter/nvim-treesitter",
		-- Uncomment next line if you want to follow only stable versions
		-- tag = "*"
	},
	["bennypowers/nvim-regexplainer"] = { -- Describe the regexp under the cursor
		opt = true,
		setup = function()
			table.insert(astronvim.file_plugins, "nvim-regexplainer")
		end,
		config = function()
			require("regexplainer").setup({
				mappings = {
					toggle = "<leader>lx",
				},
			})
		end,
		requires = {
			"nvim-treesitter/nvim-treesitter",
			"MunifTanjim/nui.nvim",
		},
	},
	["nvim-treesitter/playground"] = { -- Treesitter playground integrated into Neovim
		config = function()
			require("nvim-treesitter.configs").setup({
				playground = {
					enable = true,
					disable = {},
					updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
					persist_queries = false, -- Whether the query persists across vim sessions
					keybindings = {
						toggle_query_editor = "o",
						toggle_hl_groups = "i",
						toggle_injected_languages = "t",
						toggle_anonymous_nodes = "a",
						toggle_language_display = "I",
						focus_language = "f",
						unfocus_language = "F",
						update = "R",
						goto_node = "<cr>",
						show_help = "?",
					},
				},
			})
		end,
	},
	-- no config needed plugins
	{ "chaoren/vim-wordmotion" }, -- More useful word motions for Vim
	{ "andymass/vim-matchup" }, -- vim match-up: even better % 👊 navigate and highlight matching words 👊 modern matchit and matchparen
}
