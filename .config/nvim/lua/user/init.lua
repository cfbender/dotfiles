--              AstroNvim Configuration Table
-- All configuration changes should go inside of the table below

-- You can think of a Lua "table" as a dictionary like data structure the
-- normal format is "key = value". These also handle array like data structures
-- where a value with no key simply has an implicit numeric key
local config = {

  -- Configure AstroNvim updates
  updater = {
    remote = "origin", -- remote to use
    channel = "nightly", -- "stable" or "nightly"
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "nightly", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    auto_reload = false, -- automatically reload and sync packer after a successful update
    auto_quit = false, -- automatically quit the current session after a successful update
    -- remotes = { -- easily add new remotes to track
    --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
    --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
    --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
    -- },
  },

  -- Set colorscheme to use
  colorscheme = "tokyonight-night",

  -- Add highlight groups in any theme
  highlights = {
    init = { -- this table overrides highlights in all themes
      -- Normal = { bg = "#000000" },
    },
    -- duskfox = { -- a table of overrides/changes to the duskfox theme
    --   Normal = { bg = "#000000" },
    -- },
  },

  -- set vim options here (vim.<first_key>.<second_key> =  value)
  options = {
    opt = {
      -- set to true or false etc.
      relativenumber = true, -- sets vim.opt.relativenumber
      number = true, -- sets vim.opt.number
      spell = true, -- sets vim.opt.spell
      signcolumn = "auto", -- sets vim.opt.signcolumn to auto
      wrap = false, -- sets vim.opt.wrap
    },
    g = {
      mapleader = " ", -- sets vim.g.mapleader
      cmp_enabled = true, -- enable completion at start
      autopairs_enabled = true, -- enable autopairs at start
      diagnostics_enabled = true, -- enable diagnostics at start
      status_diagnostics_enabled = true, -- enable diagnostics in statusline
    },
  },
  -- If you need more control, you can use the function()...end notation
  -- options = function(local_vim)
  --   local_vim.opt.relativenumber = true
  --   local_vim.g.mapleader = " "
  --   local_vim.opt.whichwrap = vim.opt.whichwrap - { 'b', 's' } -- removing option from list
  --   local_vim.opt.shortmess = vim.opt.shortmess + { I = true } -- add to option list
  --
  --   return local_vim
  -- end,

  -- Set dashboard header
  header = {

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
  },

  -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  diagnostics = {
    virtual_text = true,
    underline = true,
  },

  -- Extend LSP configuration
  lsp = {
    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
    },
    formatting = {
      disabled = { -- disable formatting capabilities for the listed clients
        -- "sumneko_lua",
      },
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- easily add or disable built in mappings added during LSP attaching
    mappings = {
      n = {
        -- ["<leader>lf"] = false -- disable formatting keymap
      },
    },
    -- add to the global LSP on_attach function
    -- on_attach = function(client, bufnr)
    -- end,

    -- override the mason server-registration function
    -- server_registration = function(server, opts)
    --   require("lspconfig")[server].setup(opts)
    -- end,

    -- Add overrides for LSP server settings, the keys are the name of the server
    ["server-settings"] = {
      -- example for addings schemas to yamlls
      -- yamlls = { -- override table for require("lspconfig").yamlls.setup({...})
      --   settings = {
      --     yaml = {
      --       schemas = {
      --         ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
      --         ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
      --         ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
      --       },
      --     },
      --   },
      -- },
    },
  },

  -- Mapping data with "desc" stored directly by vim.keymap.set().
  --
  -- Please use this mappings table to set keyboard mapping since this is the
  -- lower level configuration and more robust one. (which-key will
  -- automatically pick-up stored data by this setting.)
  mappings = {
    -- first key is the mode
    n = {
      -- second key is the lefthand side of the map
      -- example mappings seen under group name "Buffer"
      -- ["<leader>bb"] = { "<cmd>tabnew<cr>", desc = "New tab" },
      -- ["<leader>bc"] = { "<cmd>BufferLinePickClose<cr>", desc = "Pick to close" },
      -- ["<leader>bj"] = { "<cmd>BufferLinePick<cr>", desc = "Pick to jump" },
      -- ["<leader>bt"] = { "<cmd>BufferLineSortByTabs<cr>", desc = "Sort by tabs" },
      -- quick save
      -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
      -- hop.nvim
      ["<leader><leader>w"] = { "<cmd>HopWord<cr>", desc = "Hop to a word" },
      ["<leader><leader>p"] = { "<cmd>HopPattern<cr>", desc = "Hop to a pattern" },
      ["<leader>bt"] = { "<cmd>BufferLineSortByTabs<cr>", desc = "Sort by tabs" },
      ["<leader>gd"] = { "<cmd>DiffviewOpen<cr>", desc = "View git diff in Diffview" },
    },
    t = {
      -- setting a mapping to false will disable it
      -- ["<esc>"] = false,
    },
  },

  -- Configure plugins
  plugins = {
    init = {
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
    },
    ["neo-tree"] = {
      filesystem = { filtered_items = { hide_dotfiles = false, hide_gitignored = false } },
    },
    -- All other entries override the require("<key>").setup({...}) call for default plugins
    ["null-ls"] = function(config) -- overrides `require("null-ls").setup(config)`
      -- config variable is the default configuration table for the setup functino call
      local null_ls = require "null-ls"

      -- Check supported formatters and linters
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
      config.sources = {
        -- Set a formatter
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.mix,
        null_ls.builtins.code_actions.eslint_d,
        null_ls.builtins.diagnostics.credo.with {
          extra_args = { "--ignore", "todo" },
        },
      }
      return config -- return final config table
    end,
    treesitter = { -- overrides `require("treesitter").setup(...)`
      ensure_installed = {
        "typescript",
        "javascript",
        "jsdoc",
        "elixir",
        "rust",
        "tsx",
        "toml",
        "fish",
        "json",
        "yaml",
        "css",
        "html",
        "lua",
      },
    },
    -- use mason-lspconfig to configure LSP installations
    ["mason-lspconfig"] = { -- overrides `require("mason-lspconfig").setup(...)`
      ensure_installed = { "elixir-ls", "typescript-language-server", "sumneko_lua" },
    },
    -- use mason-tool-installer to configure DAP/Formatters/Linter installation
    ["mason-tool-installer"] = { -- overrides `require("mason-tool-installer").setup(...)`
      ensure_installed = { "prettierd", "eslint_d", "stylua", "eslint-lsp" },
    },
    ["notify"] = {
      background_colour = "#000",
    },
  },

  -- LuaSnip Options
  luasnip = {
    -- Add paths for including more VS Code style snippets in luasnip
    vscode_snippet_paths = {},
    -- Extend filetypes
    filetype_extend = {
      -- javascript = { "javascriptreact" },
    },
  },

  -- CMP Source Priorities
  -- modify here the priorities of default cmp sources
  -- higher value == higher priority
  -- The value can also be set to a boolean for disabling default sources:
  -- false == disabled
  -- true == 1000
  cmp = {
    source_priority = {
      nvim_lsp = 1000,
      luasnip = 750,
      buffer = 500,
      path = 250,
    },
  },

  -- Modify which-key registration (Use this with mappings table in the above.)
  ["which-key"] = {
    -- Add bindings which show up as group name
    register = {
      -- first key is the mode, n == normal mode
      n = {
        -- second key is the prefix, <leader> prefixes
        ["<leader>"] = {
          -- third key is the key to bring up next level and its displayed
          -- group name in which-key top level menu
          ["b"] = { name = "Buffer" },
        },
        ["<leader>m"] = {
          name = "Diffview choose operations",
          -- third key is the key to bring up next level and its displayed
          -- group name in which-key top level menu
          o = "Choose the OURS version of a conflict",
          t = "Choose the THEIRS version of a conflict",
          b = "Choose the BASE version of a conflict",
          a = "Choose all the versions of a conflict",
        },
        ["[x"] = "Diffview previous conflict",
        ["]x"] = "Diffview next conflict",
      },
    },
  },

  -- This function is run last and is a good place to configuring
  -- augroups/autocommands and custom filetypes also this just pure lua so
  -- anything that doesn't fit in the normal config locations above can go here
  polish = function()
    -- Set up custom filetypes
    -- vim.filetype.add {
    --   extension = {
    --     foo = "fooscript",
    --   },
    --   filename = {
    --     ["Foofile"] = "fooscript",
    --   },
    --   pattern = {
    --     ["~/%.config/foo/.*"] = "fooscript",
    --   },
    -- }
  end,
}

return config
