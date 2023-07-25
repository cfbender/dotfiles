return {
	-- You can disable default plugins as follows:
	-- { "max397574/better-escape.nvim", enabled = false },
	-- customize alpha options
	{
		"goolord/alpha-nvim",
		opts = function()
			local dashboard = require("alpha.themes.dashboard")
			dashboard.section.header.val = {

				"                       ▄██▀▀▀██▄        ▄███▀▀███▄",
				"                      ██▀      ██      ▄█▀      ██▄",
				"                  ▄▄████       ██▌     ██        ████▄",
				"                 ▄██          ▄██      ▀██▄         ▀██",
				"                 ██        ████▀         ▀████       ▐█ ",
				"                 ▀█▌      █████▄         ▄████▄     ▄██",
				"                  ▀███████▀  ▀████▄   ▄████▀ ▀███████▀",
				"                                ▀███▄███▀",
				"                                  █████",
				"                                ▄███▀███▄",
				"                              ▄███▀   ▀███▄",
				"                           ▄████▀       ▀████▄",
				"                         ▄███▀             ▀███▄",
				"                       ▄██████▄           ▄██████▄",
				"                       ▀█▀███▀▀█         █▀▀███▀█▀",
				"                           ▀█▌             ▐█▀",
				"                                                  ",
				"                                                  ",
				"░█████╗░███████╗██████╗░  ░░░░░░░░░░░░  ███╗░░██╗██╗░░░██╗██╗███╗░░░███╗",
				"██╔══██╗██╔════╝██╔══██╗  ░░░░░░░░░░░░  ████╗░██║██║░░░██║██║████╗░████║",
				"██║░░╚═╝█████╗░░██████╦╝  █████╗█████╗  ██╔██╗██║╚██╗░██╔╝██║██╔████╔██║",
				"██║░░██╗██╔══╝░░██╔══██╗  ╚════╝╚════╝  ██║╚████║░╚████╔╝░██║██║╚██╔╝██║",
				"╚█████╔╝██║░░░░░██████╦╝  ░░░░░░░░░░░░  ██║░╚███║░░╚██╔╝░░██║██║░╚═╝░██║",
				"░╚════╝░╚═╝░░░░░╚═════╝░  ░░░░░░░░░░░░  ╚═╝░░╚══╝░░░╚═╝░░░╚═╝╚═╝░░░░░╚═╝",
			}
			dashboard.section.header.opts.hl = "DashboardHeader"

			local button = require("alpha.themes.dashboard").button
			dashboard.section.buttons.val = {
				button("f", "  Find File", ":Telescope find_files<cr>"),
				button("e", "  Browse Files", "<cmd>:Neotree reveal<cr>"),
				button("r", "󱋡  Recent Files", ":Telescope oldfiles<cr>"),
				button("t", "󰈞  Find Text", ":Telescope live_grep<cr>"),
				button("s", "󰮲  Load previous session", "<cmd>SessionManager! load_last_session<cr>"),
				button("u", "  Update Plugins", ":Lazy sync<CR>"),
				button("q", "  Quit Neovim", ":qa!<CR>"),
			}

			local footer = function()
				local updater = require("astronvim.utils.updater")
				local neovim_version = "  v"
					.. vim.version().major
					.. "."
					.. vim.version().minor
					.. "."
					.. vim.version().patch
				local astronvim_version = updater.version(true)
				local stats = require("lazy").stats()
				local ms = math.floor(stats.startuptime * 100 + 0.5) / 100

				local versions = neovim_version .. "   AstroNvim " .. astronvim_version .. " loaded "
				local total_plugins = stats.count .. " plugins in " .. ms .. " ms "
				return versions .. total_plugins
			end

			dashboard.section.footer.val = footer()
			dashboard.section.footer.opts.hl = "DashboardFooter"

			dashboard.config.layout[1].val = vim.fn.max({ 2, vim.fn.floor(vim.fn.winheight(0) * 0.2) })
			dashboard.config.layout[3].val = 5
			dashboard.config.opts.noautocmd = true
			return dashboard
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		config = function(plugin, opts)
			require("plugins.configs.luasnip")(plugin, opts) -- include the default astronvim config that calls the setup call
			-- add more custom luasnip configuration such as filetype extend or custom snippets
			local luasnip = require("luasnip")
			luasnip.filetype_extend("javascript", { "javascriptreact" })
			luasnip.filetype_extend("typescript", { "typescriptreact" })
		end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		opts = function()
			return {
				window = { position = "right" },
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
	{ "rcarriga/nvim-notify", opts = {
		background_colour = "#000",
		top_down = false,
		timeout = 2000,
	} },
}
