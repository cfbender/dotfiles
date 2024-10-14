-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {
  "andweeb/presence.nvim",
  -- configuring builtins
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local status = require "astroui.status"
      -- local codeium_status = {
      -- 	provider = " Codeium: " .. vim.fn["codeium#GetStatusString"](),
      -- }
      opts.statusline = { -- statusline
        hl = { fg = "fg", bg = "bg" },
        status.component.mode { mode_text = { padding = { left = 1, right = 1 } } }, -- add the mode text
        status.component.git_branch(),
        status.component.file_info { filetype = {}, filename = false, file_modified = false },
        status.component.git_diff(),
        status.component.diagnostics(),
        status.component.fill(),
        status.component.fill(),
        status.component.lsp(),
        -- remove the 2nd mode indicator on the right
      }

      -- return the final configuration table
      return opts
    end,
  },

  {
    "goolord/alpha-nvim",
    opts = function()
      local dashboard = require "alpha.themes.dashboard"
      dashboard.section.header.val = require("helpers.ascii").ICANT

      dashboard.section.header.opts.hl = "DashboardHeader"

      local button = require("alpha.themes.dashboard").button
      dashboard.section.buttons.val = {
        button("f", "  Find File", ":Telescope find_files<cr>"),
        button("e", "  Browse Files", "<cmd>:Neotree reveal<cr>"),
        button("r", "󱋡  Recent Files", ":Telescope oldfiles<cr>"),
        button("t", "󰈞  Find Text", ":Telescope live_grep<cr>"),
        button("s", "󰮲  Load previous session", "<cmd>SessionManager! load_last_session<cr>"),
        button("u", "  Update Plugins", ":AstroUpdate <CR>"),
        button("q", "  Quit Neovim", ":qa!<CR>"),
      }

      local footer = function()
        local neovim_version = "  v"
          .. vim.version().major
          .. "."
          .. vim.version().minor
          .. "."
          .. vim.version().patch
        local stats = require("lazy").stats()
        local ms = math.floor(stats.startuptime * 100 + 0.5) / 100

        local versions = neovim_version .. "   AstroNvim loaded "
        local total_plugins = stats.count .. " plugins in " .. ms .. " ms "
        return versions .. total_plugins
      end

      dashboard.section.footer.val = footer()
      dashboard.section.footer.opts.hl = "DashboardFooter"

      dashboard.config.layout[1].val = vim.fn.max { 2, vim.fn.floor(vim.fn.winheight(0) * 0.2) }
      dashboard.config.layout[3].val = 5
      dashboard.config.opts.noautocmd = true
      return dashboard
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
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

  -- adding new plugins
  { "max397574/better-escape.nvim" },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
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
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require("rose-pine").setup {
        variant = "main", -- auto, main, moon, or dawn
        dark_variant = "main", -- main, moon, or dawn
        dim_inactive_windows = false,
        extend_background_behind_borders = true,

        enable = {
          terminal = true,
          legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
          migrations = true, -- Handle deprecated options automatically
        },

        styles = {
          bold = true,
          italic = false,
          transparency = false,
        },
      }
    end,
  },
  {
    "catppuccin/nvim", -- Soothing pastel theme for Neovim
    name = "catppuccin",
    config = function()
      require("catppuccin").setup {
        flavour = "frappe",
        dim_inactive = { enabled = true, percentage = 0.25 },
        integrations = {
          cmp = true,
          dap = true,
          dap_ui = true,
          hop = true,
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
      }
    end,
    lazy = false,
    priority = 1000,
  },
  {
    "phaazon/hop.nvim", -- Neovim motions on speed!
    branch = "v2", -- optional but strongly recommended,
    config = function() require("hop").setup() end,
    module = "hop",
    event = "BufRead",
    opt = true,
  },
  {
    "folke/neodev.nvim", -- 💻 Dev setup for init.lua and plugin development with full signature help, docs and completion for the nvim lua API.
    opt = true,
    event = "BufEnter *.lua",
    config = function()
      require("neodev").setup {
        library = { plugins = { "neotest" }, types = true },
      }
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
      require("neotest").setup {
        discovery = {
          concurrent = 1,
        },
        adapters = {
          require "neotest-elixir",
          require "neotest-vitest",
          require "neotest-jest" {
            jestCommand = "npm test --",
            cwd = function() return vim.fn.getcwd() end,
          },
        },
      }
    end,
  },
  {
    "andythigpen/nvim-coverage",
    dependencies = "nvim-lua/plenary.nvim",
    event = "User AstroFile",
    config = function()
      require("coverage").setup {
        lcov_file = "./cover/lcov.info",
      }
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
    config = function() require("octo").setup() end,
  },
  {
    "danymat/neogen", -- A better annotation generator. Supports multiple languages and annotation conventions.
    enabled = false, -- TODO: Maybe PR a generator for elixir typespecs a la VS Code
    opt = true,
    event = "BufRead",
    config = function() require("neogen").setup {} end,
    requires = "nvim-treesitter/nvim-treesitter",
    -- Uncomment next line if you want to follow only stable versions
    -- tag = "*"
  },
  {
    "nvim-treesitter/playground", -- Treesitter playground integrated into Neovim
    enabled = false, -- only turn on for debugging treesitter
    config = function()
      require("nvim-treesitter.configs").setup {
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
      }
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {
        -- Configuration here, or leave empty to use defaults
      }
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
  -- no config needed plugins
  { "chaoren/vim-wordmotion", event = "BufRead" }, -- More useful word motions for Vim
  { "andymass/vim-matchup", event = "BufRead" }, -- vim match-up: even better % 👊 navigate and highlight matching words 👊 modern matchit and matchparen
}
