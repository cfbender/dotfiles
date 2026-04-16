---@diagnostic disable: inject-field
-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {
	-- == Overriding Built-in Plugins ==
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

	{
		"folke/snacks.nvim",
		dependencies = { "HiPhish/rainbow-delimiters.nvim" },
		opts = {
			-- customize dashboard options
			dashboard = {
				sections = {
					function()
						return vim.tbl_extend("force", {
							section = "terminal",
							padding = 1,
						}, require("helpers.chafa").sakura)
					end,
					{ section = "keys", gap = 1, padding = 2 },
					-- { pane = 2, padding = 12 },
					{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
					{

						icon = " ",
						title = "Git Status",
						section = "terminal",
						enabled = function()
							return require("snacks").git.get_root() ~= nil
						end,
						cmd = "git status --short --branch --renames",
						height = 5,
						padding = 1,
						ttl = 5 * 60,
						indent = 3,
					},
					{ section = "startup" },
				},
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
							key = "t",
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
			indent = {
				scope = {
					hl = vim.tbl_get(vim.g, "rainbow_delimiters", "highlight") or {
						"RainbowDelimiterRed",
						"RainbowDelimiterYellow",
						"RainbowDelimiterBlue",
						"RainbowDelimiterOrange",
						"RainbowDelimiterGreen",
						"RainbowDelimiterViolet",
						"RainbowDelimiterCyan",
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
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
	},

	-- == Community overrides ==
	{
		"catppuccin",
		opts = {
			flavour = "mocha",
			integrations = {
				blink_cmp = true,
				dap = true,
				dap_ui = true,
				flash = true,
				mason = true,
				mini = {
					enabled = true,
					indentscope_color = "lavender",
				},
				octo = true,
				rainbow_delimiters = true,
				snacks = {
					enabled = true,
					indent_scope_color = "lavender",
				},
				which_key = true,
			},
		},
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
		"cbochs/grapple.nvim",
		opts = {
			scope = "git_branch",
		},
	},
	{ "telescope.nvim", enabled = false }, -- disable because of haskell pack
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			if not opts.formatters_by_ft then
				opts.formatters_by_ft = {}
			end

			opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft, {
				elixir = { "mix" },
				javascript = { "biome" },
				javascriptreact = { "biome" },
				typescript = { "biome" },
				typescriptreact = { "biome" },
				haskell = { "fourmolu" },
			})

			return opts
		end,
	},
	{
		"mrcjkb/haskell-tools.nvim",
		version = "^6",
		init = function()
			local astrolsp_avail, astrolsp = pcall(require, "astrolsp")
			local base_opts = astrolsp_avail
					and {
						capabilities = astrolsp.config.capabilities,
						on_attach = astrolsp.on_attach,
					}
				or {}

			local opts = require("astrocore").extend_tbl({
				settings = {
					haskell = {
						plugin = {
							hlint = {
								--https://github.com/haskell/haskell-language-server/issues/4674
								diagnosticsOn = false,
							},
						},
					},
				},
			}, base_opts)

			vim.g.haskell_tools = require("astrocore").extend_tbl({
				hls = opts,
			}, vim.g.haskell_tools)
		end,
	},
	-- == Extra Plugins ==
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
		"mikavilpas/yazi.nvim",
		event = "BufEnter",
		dependencies = { "folke/snacks.nvim", lazy = true },
		keys = {
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
	{
		"mfussenegger/nvim-lint",
		event = "VeryLazy",
		config = function()
			require("lint").linters_by_ft = {
				haskell = { "hlint" },
			}
		end,
	},
	{
		"folke/sidekick.nvim",
		specs = {
			{
				"AstroNvim/astrocore",
				---@param opts AstroCoreOpts
				opts = function(_, opts)
					local maps = assert(opts.mappings)
					local prefix = "<Leader>A"

					local function ask_input(context_var, selection_text)
						require("snacks").input({
							prompt = "Ask about this:",
							icon = "󰚩 ",
							win = {
								title_pos = "left",
								relative = "cursor",
								row = -3, -- Row above the cursor
								col = 0, -- Align with the cursor
								keys = {
									i_cr = {
										"<CR>",
										function(self)
											local text = self:text()
											if not text or text == "" then
												return
											end
											self:close()
											vim.schedule(function()
												local msg = selection_text and (text .. "\n" .. selection_text)
													or (text .. " " .. context_var)
												require("sidekick.cli").send({ msg = msg, submit = true })
											end)
										end,
										mode = { "i", "n" },
										desc = "submit",
									},
									i_s_cr = {
										"<S-CR>",
										function(self)
											local text = self:text()
											if not text or text == "" then
												return
											end
											self:close()
											vim.schedule(function()
												local msg = selection_text and (text .. "\n" .. selection_text)
													or (text .. " " .. context_var)
												require("sidekick.cli").send({ msg = msg })
											end)
										end,
										mode = "i",
										desc = "append",
									},
								},
								footer = {
									{ " ", "SnacksFooter" },
									{ " <CR> ", "SnacksFooterKey" },
									{ " submit ", "SnacksFooterDesc" },
									{ " ", "SnacksFooter" },
									{ " <S-CR> ", "SnacksFooterKey" },
									{ " append ", "SnacksFooterDesc" },
									{ " ", "SnacksFooter" },
								},
							},
						}, function() end)
					end

					-- Normal mode mappings overrides
					maps.n[prefix .. "a"] = {
						function()
							ask_input("{this}")
						end,
						desc = "Ask about this",
					}
					maps.n[prefix .. "s"] = nil
					maps.n[prefix .. "d"] = nil

					-- Visual mode mappings overrides
					maps.x[prefix] = { desc = require("astroui").get_icon("Sidekick", 1, true) .. "Sidekick" }
					maps.x[prefix .. "a"] = {
						function()
							local region =
								vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
							local selection = table.concat(region, "\n")
							ask_input("{selection}", selection)
						end,
						desc = "Ask about selection",
					}
				end,
			},
		},
	},

	-- == No Config Needed Plugins ==

	{ "chaoren/vim-wordmotion", event = "BufRead" }, -- More useful word motions for Vim
	{ "andymass/vim-matchup", event = "BufRead" }, -- vim match-up: even better % 👊 navigate and highlight matching words 👊 modern matchit and matchparen

	-- == Temporary Plugins ==

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
}
