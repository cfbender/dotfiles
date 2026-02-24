-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
	"AstroNvim/astrocore",
	---@type AstroCoreOpts
	opts = {
		-- Configure core features of AstroNvim
		features = {
			large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
			autopairs = true, -- enable autopairs at start
			blink_cmp = true,
			diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
			highlighturl = true, -- highlight URLs at start
			notifications = true, -- enable notifications at start
		},
		-- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
		diagnostics = {
			virtual_text = true,
			underline = true,
		},
		-- vim options can be configured here
		options = {
			opt = { -- vim.opt.<key>
				relativenumber = false, -- sets vim.opt.relativenumber
				number = true, -- sets vim.opt.number
				spell = true, -- sets vim.opt.spell
				signcolumn = "yes", -- sets vim.opt.signcolumn to yes
				wrap = false, -- sets vim.opt.wrap
				clipboard = "unnamedplus",
			},
			g = { -- vim.g.<key>
				-- configure global vim variables (vim.g)
				-- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
				-- This can be found in the `lua/lazy_setup.lua` file
			},
		},
		-- Mappings can be configured through AstroCore as well.
		-- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
		mappings = {
			-- first key is the mode
			v = {
				["<C-c><C-c>"] = {
					desc = "Send to Vimux",
					function()
						-- yank text into v register
						if vim.api.nvim_get_mode()["mode"] == "n" then
							vim.cmd('normal vip"vy')
						else
							vim.cmd('normal "vy')
						end
						-- construct command with v register as command to send
						-- vim.cmd(string.format('call VimuxRunCommand("%s")', vim.trim(vim.fn.getreg('v'))))
						vim.cmd("call VimuxRunCommand(@v)")
					end,
				},
			},
			n = {
				["\\"] = false,
				["|"] = false,
				["<C-c><C-c>"] = {
					desc = "Send to Vimux",
					function()
						-- yank text into v register
						if vim.api.nvim_get_mode()["mode"] == "n" then
							vim.cmd('normal vip"vy')
						else
							vim.cmd('normal "vy')
						end
						-- construct command with v register as command to send
						-- vim.cmd(string.format('call VimuxRunCommand("%s")', vim.trim(vim.fn.getreg('v'))))
						vim.cmd("call VimuxRunCommand(@v)")
					end,
				},
				gl = {
					function()
						vim.diagnostic.open_float()
					end,
					desc = "Hover diagnostics",
				},
				-- second key is the lefthand side of the map
				["<leader>bt"] = { "<cmd>BufferLineSortByTabs<cr>", desc = "Sort by tabs" },

				["<leader>gj"] = {
					function()
						require("gitsigns").nav_hunk("next")
					end,
					desc = "Next Git hunk",
				},
				["<leader>gk"] = {
					function()
						require("gitsigns").nav_hunk("prev")
					end,
					desc = "Previous Git hunk",
				},
				-- snacks
				["<leader>fx"] = {
					function()
						require("snacks").picker.grep_buffers()
					end,
					desc = "Find word in open buffers",
				},
				["<leader>fd"] = {
					function()
						require("snacks").picker.diagnostics()
					end,
					desc = "Find diagnostics",
				},
				["<leader>fD"] = {
					function()
						require("snacks").picker.diagnostics_buffer()
					end,
					desc = "Find diagnostics in open buffer",
				},
				["<leader>f."] = {
					function()
						local word = vim.fn.expand("<cword>")
						local ft = vim.bo.filetype
						if ft == "elixir" then
							require("snacks").picker.grep({ search = "def " .. word .. "\\(" })
						elseif
							ft == "typescript"
							or ft == "typescriptreact"
							or ft == "javascript"
							or ft == "javascriptreact"
						then
							require("snacks").picker.grep({ search = "(const|let|function) " .. word .. "[\\( =]" })
						else
							require("snacks").picker.grep_word()
						end
					end,
					desc = "Find definition of word under cursor",
				},
				["<leader>sp"] = {
					function()
						require("snacks").picker.lazy()
					end,
					desc = "Search for Plugin Spec",
				},
				["<leader>sq"] = {
					function()
						require("snacks").picker.qflist()
					end,
					desc = "Quickfix List",
				},
				["<leader>si"] = {
					function()
						require("snacks").picker.icons()
					end,
					desc = "Icons",
				},
				["<leader>fi"] = {
					function()
						require("helpers.snacks").pick_biome_search()
					end,
					desc = "Biome search",
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

				-- mappings seen under group name "Buffer"
				["<Leader>bD"] = {
					function()
						require("astroui.status.heirline").buffer_picker(function(bufnr)
							require("astrocore.buffer").close(bufnr)
						end)
					end,
					desc = "Pick to close",
				},
				-- tables with just a `desc` key will be registered with which-key if it's installed
				-- this is useful for naming menus
				["<Leader>b"] = { desc = "Buffers" },
				L = {
					function()
						require("astrocore.buffer").nav(vim.v.count > 0 and vim.v.count or 1)
					end,
					desc = "Next buffer",
				},
				H = {
					function()
						require("astrocore.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1))
					end,
					desc = "Previous buffer",
				},
			},
		},
		autocmds = {
			lint = {
				{
					event = { "BufEnter", "InsertLeave", "TextChanged", "BufWritePost" },
					desc = "Lint file on haskell buffer changed",
					callback = function()
						if vim.bo.filetype ~= "haskell" then
							return
						end

						-- try_lint without arguments runs the linters defined in `linters_by_ft`
						-- for the current filetype
						require("lint").try_lint("hlint")
					end,
				},
			},
		},
	},
}
