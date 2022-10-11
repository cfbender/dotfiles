return {
	-- You can disable default plugins as follows:
	-- ["goolord/alpha-nvim"] = { disable = true },
	["catppuccin/nvim"] = require("user.plugins.custom.catppuccin"), -- Soothing pastel theme for Neovim
	["phaazon/hop.nvim"] = require("user.plugins.custom.hop"), -- Neovim motions on speed!
	["sindrets/diffview.nvim"] = require("user.plugins.custom.diffview"), -- Single tabpage interface for easily cycling through diffs for all modified files for any git rev.
	["ray-x/lsp_signature.nvim"] = require("user.plugins.custom.lsp_signature"), -- LSP signature hint as you type
	["bennypowers/nvim-regexplainer"] = require("user.plugins.custom.regexplainer"), -- Describe the regexp under the cursor
	["folke/lua-dev.nvim"] = require("user.plugins.custom.lua-dev"), -- 💻 Dev setup for init.lua and plugin development with full signature help, docs and completion for the nvim lua API.
	-- no config needed plugins
	{ "chaoren/vim-wordmotion" }, -- More useful word motions for Vim
}
