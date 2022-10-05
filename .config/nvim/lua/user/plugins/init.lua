return {
  {
    "folke/tokyonight.nvim",
    config = function()
      require("tokyonight").setup {
        style = "night",
        transparent = true,
        italic_functions = true,
        italic_variables = true,
        sidebars = { "qf", "vista_kind", "terminal", "packer" },
      }
    end,
  },
  {
    "phaazon/hop.nvim",
    branch = "v2", -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require("hop").setup()
    end,
  },
  { "chaoren/vim-wordmotion" },
  { "APZelos/blamer.nvim" },
  {
    "sindrets/diffview.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      local actions = require "diffview.actions"
      require("diffview").setup {
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
            ["<leader>mo"] = actions.conflict_choose "ours", -- Choose the OURS version of a conflict
            ["<leader>mt"] = actions.conflict_choose "theirs", -- Choose the THEIRS version of a conflict
            ["<leader>mb"] = actions.conflict_choose "base", -- Choose the BASE version of a conflict
            ["<leader>ma"] = actions.conflict_choose "all", -- Choose all the versions of a conflict
          },
        },
      }
    end,
  },

  -- You can disable default plugins as follows:
  -- ["goolord/alpha-nvim"] = { disable = true },

  -- You can also add new plugins here as well:
  -- Add plugins, the packer syntax without the "use"
  -- { "andweeb/presence.nvim" },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },

  -- We also support a key value style plugin definition similar to NvChad:
  -- ["ray-x/lsp_signature.nvim"] = {
  --   event = "BufRead",
  --   config = function()
  --     require("lsp_signature").setup()
  --   end,
  -- },
  --
}
