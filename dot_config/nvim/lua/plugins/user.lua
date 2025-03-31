-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {

	-- == Examples of Adding Plugins ==

	"andweeb/presence.nvim",
	{
		"ray-x/lsp_signature.nvim",
		event = "BufRead",
		config = function()
			require("lsp_signature").setup()
		end,
	},

	-- == Examples of Overriding Plugins ==
	{
		"rebelot/heirline.nvim",
		opts = function(_, opts)
			local status = require("astroui.status")
			-- local codeium_status = {
			-- 	provider = " Codeium: " .. vim.fn["codeium#GetStatusString"](),
			-- }
			-- custom heirline statusline component for grapple
			---@diagnostic disable-next-line: inject-field
			status.component.grapple = {
				provider = function()
					local available, grapple = pcall(require, "grapple")
					if available then
						return grapple.statusline()
					end
				end,
			}
			opts.statusline = { -- statusline
				hl = { fg = "fg", bg = "bg" },
				status.component.mode({ mode_text = { padding = { left = 1, right = 1 } } }), -- add the mode text
				status.component.git_branch(),
				status.component.grapple,
				status.component.file_info({ filetype = {}, filename = false, file_modified = false }),
				status.component.git_diff(),
				status.component.diagnostics(),
				status.component.fill(),
				status.component.fill(),
				status.component.lsp(),
				status.component.treesitter(),
				status.component.nav(),
				status.component.mode({ surround = { separator = "right" } }),
				-- remove the 2nd mode indicator on the right
			}

			-- return the final configuration table
			return opts
		end,
	},

	-- customize dashboard options
	{
		"folke/snacks.nvim",
		opts = {
			dashboard = {
				preset = {
					header = table.concat(require("helpers.ascii").LETSGO, "\n"),
					---@type snacks.dashboard.Item[]
					keys = {
						{
							icon = " ",
							key = "f",
							desc = "Find File",
							action = ":lua Snacks.dashboard.pick('files')",
						},
						{
							icon = "󰥨 ",
							key = "e",
							desc = "Browse Files",
							action = "<cmd>Yazi cwd<cr>",
						},
						{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
						{
							icon = " ",
							key = "g",
							desc = "Find Text",
							action = ":lua Snacks.dashboard.pick('live_grep')",
						},
						{
							icon = " ",
							key = "r",
							desc = "Recent Files",
							action = ":lua Snacks.dashboard.pick('oldfiles')",
						},
						{
							icon = " ",
							key = "c",
							desc = "Config",
							action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
						},
						{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
						{
							icon = "󰒲 ",
							key = "u",
							desc = "Update Plugins",
							action = ":AstroUpdate",
						},
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
					},
				},
			},
		},
	},

	{
		"L3MON4D3/LuaSnip",
		config = function(plugin, opts)
			require("astronvim.plugins.configs.luasnip")(plugin, opts) -- include the default astronvim config that calls the setup call
			-- add more custom luasnip configuration such as filetype extend or custom snippets
			local luasnip = require("luasnip")
			luasnip.filetype_extend("javascript", { "javascriptreact" })
			luasnip.filetype_extend("typescript", { "typescriptreact" })
		end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		enabled = false,
		opts = function()
			return {
				window = { position = "left" },
				filesystem = {
					follow_current_file = true,
					hijack_netrw_behavior = "open_default",
					cwd_target = {
						sidebar = "window",
					},
					filtered_items = {
						-- use H in neo-tree to un-hide hidden items if you need em
						hide_dotfiles = true,
						hide_gitignored = false,
						hide_by_name = { "node_modules", "_build", ".git", "deps" },
					},
				},
			}
		end,
	},

	{
		"windwp/nvim-autopairs",
		config = function(plugin, opts)
			require("astronvim.plugins.configs.nvim-autopairs")(plugin, opts) -- include the default astronvim config that calls the setup call
			-- add more custom autopairs configuration such as custom rules
			local npairs = require("nvim-autopairs")
			local Rule = require("nvim-autopairs.rule")
			local cond = require("nvim-autopairs.conds")
			npairs.add_rules(
				{
					Rule("$", "$", { "tex", "latex" })
						-- don't add a pair if the next character is %
						:with_pair(cond.not_after_regex("%%"))
						-- don't add a pair if  the previous character is xxx
						:with_pair(
							cond.not_before_regex("xxx", 3)
						)
						-- don't move right when repeat character
						:with_move(cond.none())
						-- don't delete if the next character is xx
						:with_del(cond.not_after_regex("xx"))
						-- disable adding a newline when you press <cr>
						:with_cr(cond.none()),
				},
				-- disable for .vim files, but it work for another filetypes
				Rule("a", "a", "-vim")
			)
		end,
	},
	-- COLORSCHEMES
	"shaunsingh/nord.nvim",
	"Mofiqul/dracula.nvim",
	"rebelot/kanagawa.nvim",
	{
		"catppuccin/nvim", -- Soothing pastel theme for Neovim
		name = "catppuccin",
		opts = {
			flavour = "frappe",
			dim_inactive = { enabled = true, percentage = 0.25 },
			integrations = {
				cmp = true,
				dap = true,
				dap_ui = true,
				flash = true,
				gitsigns = true,
				mason = true,
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
						ok = { "italic" },
					},
					underlines = {
						errors = { "underline" },
						hints = { "underline" },
						warnings = { "underline" },
						information = { "underline" },
						ok = { "underline" },
					},
					inlay_hints = {
						background = true,
					},
				},
				neotest = true,
				neotree = true,
				notify = true,
				nvimtree = false,
				octo = true,
				sandwich = true,
				semantic_tokens = true,
				symbols_outline = true,
				telescope = { enabled = true },
				treesitter = true,
				which_key = true,
			},
		},
		lazy = false,
		priority = 1000,
	},
	{
		"nvim-neotest/neotest", -- An extensible framework for interacting with tests within NeoVim.
		enabled = false,
		dependencies = {
			"jfpedroza/neotest-elixir",
			"marilari88/neotest-vitest",
			"haydenmeade/neotest-jest",
			"mrcjkb/neotest-haskell",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-elixir"),
					require("neotest-vitest"),
					require("neotest-haskell"),
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
		enabled = false,
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
			---@diagnostic disable-next-line: missing-fields
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
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
	{
		"preservim/vimux",
		event = "VeryLazy",
		init = function()
			vim.g.VimuxOrientation = "h"
			vim.g.VimuxHeight = "30"
			vim.g.VimuxCloseOnExit = true
		end,
	},
	{
		"MeanderingProgrammer/markdown.nvim",
		main = "render-markdown",
		event = "VeryLazy",
		opts = {},
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
	},
	{
		"cbochs/grapple.nvim",
		opts = {
			scope = "git_branch",
		},
	},
	{
		"zbirenbaum/copilot.lua",
		opts = {
			suggestion = {
				keymap = {
					accept = "<M-=>",
				},
			},
		},
	},
	{
		"mrcjkb/haskell-tools.nvim",
		enabled = false,
		init = function()
			local astrolsp_avail, astrolsp = pcall(require, "astrolsp")
			vim.g.haskell_tools = require("astrocore").extend_tbl({
				hls = astrolsp_avail and {
					capabilities = astrolsp.config.capabilities,
					on_attach = astrolsp.on_attach,
					settings = { haskell = { formattingProvider = "ormolu" } },
				} or {
					settings = { haskell = { formattingProvider = "ormolu" } },
				},
			}, vim.g.haskell_tools)
		end,
	},
	{
		"elixir-tools/elixir-tools.nvim",
		version = "*",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local elixir = require("elixir")
			local elixirls = require("elixir.elixirls")

			elixir.setup({
				nextls = { enable = false },
				elixirls = {
					enable = true,
					repo = "elixir-lsp/elixir-ls",
					tag = "v0.27.2",
					settings = elixirls.settings({
						dialyzerEnabled = true,
						incrementalDialyzer = true,
						fetchDeps = true,
						suggestSpecs = true,
						enableTestLenses = false,
					}),
					-- on_attach = function(client, bufnr)
					-- vim.keymap.set("n", "<leader>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
					-- vim.keymap.set("n", "<leader>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
					-- vim.keymap.set("v", "<leader>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
					-- end,
				},
				credo = { enable = true },
				projectionist = {
					enable = true,
				},
			})
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"mikavilpas/yazi.nvim",
		event = "BufEnter",
		dependencies = { "folke/snacks.nvim", lazy = true },
		keys = {
			-- 👇 in this section, choose your own keymappings!
			{
				"<leader>e",
				mode = { "n", "v" },
				"<cmd>Yazi<cr>",
				desc = "Open yazi at the current file",
			},
			{
				-- Open in the current working directory
				"<leader>.",
				"<cmd>Yazi cwd<cr>",
				desc = "Open the file manager in nvim's working directory",
			},
			{
				"<leader>re",
				"<cmd>Yazi toggle<cr>",
				desc = "Resume the last yazi session",
			},
		},
		---@type YaziConfig | {}
		opts = {
			-- if you want to open yazi instead of netrw, see below for more info
			open_for_directories = true,
			keymaps = {
				show_help = "<f1>",
				open_file_in_vertical_split = "<c-v>",
				open_file_in_horizontal_split = "<c-x>",
				open_file_in_tab = "<c-t>",
				grep_in_directory = "<c-s>",
				replace_in_directory = "<c-g>",
				cycle_open_buffers = "<tab>",
				copy_relative_path_to_selected_files = "<c-y>",
				send_to_quickfix_list = "<c-q>",
				change_working_directory = "<c-\\>",
			},
		},
		-- 👇 if you use `open_for_directories=true`, this is recommended
		init = function()
			-- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
			-- vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
		end,
	},
	-- no config needed plugins
	{ "chaoren/vim-wordmotion", event = "BufRead" }, -- More useful word motions for Vim
	{ "andymass/vim-matchup", event = "BufRead" }, -- vim match-up: even better % 👊 navigate and highlight matching words 👊 modern matchit and matchparen
}
