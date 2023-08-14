return {
	-- You can disable default plugins as follows:
	-- {"goolord/alpha-nvim", enabled = false},
	{
		"catppuccin/nvim", -- Soothing pastel theme for Neovim
		name = "catppuccin",
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				dim_inactive = { enabled = true, percentage = 0.25 },
				integrations = {
					cmp = true,
					dap = { enabled = true, enable_ui = true },
					hop = true,
					mason = true,
					neotest = true,
					neotree = true,
					notify = true,
					nvimtree = false,
					octo = true,
					sandwich = true,
					semantic_tokens = true,
					symbols_outline = true,
					telescope = { enabled = true },
					which_key = true,
				},
			})

			vim.cmd([[colorscheme catppuccin]])
		end,
		lazy = false,
		priority = 1000,
	},
	{
		"phaazon/hop.nvim", -- Neovim motions on speed!
		branch = "v2", -- optional but strongly recommended,
		config = function()
			require("hop").setup()
		end,
		module = "hop",
		event = "BufRead",
		opt = true,
	},
	{
		"folke/neodev.nvim", -- 💻 Dev setup for init.lua and plugin development with full signature help, docs and completion for the nvim lua API.
		opt = true,
		event = "BufEnter *.lua",
		config = function()
			require("neodev").setup({
				library = { plugins = { "neotest" }, types = true },
			})
		end,
	},
	{
		"nvim-neotest/neotest", -- An extensible framework for interacting with tests within NeoVim.
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"jfpedroza/neotest-elixir",
			"marilari88/neotest-vitest",
			"haydenmeade/neotest-jest",
		},
		lazy = false,
		config = function()
			require("neotest").setup({
				discovery = {
					concurrent = 1,
				},
				adapters = {
					require("neotest-elixir"),
					require("neotest-vitest"),
					require("neotest-jest")({
						jestCommand = "npm test --",
						cwd = function()
							return vim.fn.getcwd()
						end,
					}),
				},
			})
		end,
	},
	{
		"andythigpen/nvim-coverage",
		dependencies = "nvim-lua/plenary.nvim",
		event = "User AstroFile",
		config = function()
			require("coverage").setup({
				lcov_file = "./cover/lcov.info",
			})
		end,
	},
	{
		"pwntester/octo.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("octo").setup()
		end,
	},
	{
		"danymat/neogen", -- A better annotation generator. Supports multiple languages and annotation conventions.
		enabled = false, -- TODO: Maybe PR a generator for elixir typespecs a la VS Code
		opt = true,
		event = "BufRead",
		config = function()
			require("neogen").setup({})
		end,
		requires = "nvim-treesitter/nvim-treesitter",
		-- Uncomment next line if you want to follow only stable versions
		-- tag = "*"
	},
	{
		"nvim-treesitter/playground", -- Treesitter playground integrated into Neovim
		enabled = false, -- only turn on for debugging treesitter
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
	{ "chaoren/vim-wordmotion", event = "BufRead" }, -- More useful word motions for Vim
	{ "andymass/vim-matchup", event = "BufRead" }, -- vim match-up: even better % 👊 navigate and highlight matching words 👊 modern matchit and matchparen
}
