-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
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
        spell = false, -- sets vim.opt.spell
        signcolumn = "auto", -- sets vim.opt.signcolumn to auto
        wrap = false, -- sets vim.opt.wrap
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
              vim.cmd 'normal vip"vy'
            else
              vim.cmd 'normal "vy'
            end
            -- construct command with v register as command to send
            -- vim.cmd(string.format('call VimuxRunCommand("%s")', vim.trim(vim.fn.getreg('v'))))
            vim.cmd "call VimuxRunCommand(@v)"
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
              vim.cmd 'normal vip"vy'
            else
              vim.cmd 'normal "vy'
            end
            -- construct command with v register as command to send
            -- vim.cmd(string.format('call VimuxRunCommand("%s")', vim.trim(vim.fn.getreg('v'))))
            vim.cmd "call VimuxRunCommand(@v)"
          end,
        },
        gl = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics" },
        -- second key is the lefthand side of the map
        -- hop.nvim
        ["<leader><space>"] = { name = "Hop" },
        ["<leader><leader>w"] = { "<cmd>HopWord<cr>", desc = "Hop to a word" },
        ["<leader><leader>p"] = { "<cmd>HopPattern<cr>", desc = "Hop to a pattern" },
        ["<leader>bt"] = { "<cmd>BufferLineSortByTabs<cr>", desc = "Sort by tabs" },
        ["<leader>gj"] = {
          function() require("gitsigns").next_hunk() end,
          desc = "Next Git hunk",
        },
        ["<leader>gk"] = {
          function() require("gitsigns").prev_hunk() end,
          desc = "Previous Git hunk",
        },
        ["<leader>ff"] = { "<cmd>Telescope git_files<cr>", desc = "Search all files in git" },
        ["<leader>fr"] = { "<cmd>Telescope resume<cr>", desc = "Resume previous telescope search" },
        ["<leader>lg"] = { "<cmd>Neogen<cr>", desc = "Generate annotation for the current node" },
        -- neotest
        ["<leader>n"] = { name = " Neotest", desc = " Neotest" },
        ["<leader>nn"] = {
          function() require("neotest").run.run() end,
          desc = "Run the nearest test",
        },
        ["<leader>nd"] = {
          function() require("neotest").run.run { strategy = "dap" } end,
          desc = "Debug the nearest test",
        },
        ["<leader>ns"] = {
          function() require("neotest").summary.toggle() end,
          desc = "Toggle test summary",
        },
        ["<leader>nf"] = {
          function() require("neotest").run.run(vim.fn.expand "%") end,
          desc = "Run tests for the current file",
        },
        -- copilot
        ["<leader>k"] = { name = " Copilot" },
        ["<leader>kp"] = {
          "<cmd>Copilot panel<cr>",
          desc = "Open copilot panel",
        },
        ["<leader>kt"] = {
          function()
            local copilot = require "copilot.suggestion"
            copilot.toggle_auto_trigger()
          end,
          desc = "Toggle suggestions",
        },
        -- coverage
        ["<leader>lc"] = {
          function() require("coverage").toggle() end,
          desc = "Toggle coverage info",
        },
        -- resize with arrows
        ["<Up>"] = {
          function() require("smart-splits").resize_up(2) end,
          desc = "Resize split up",
        },
        ["<Down>"] = {
          function() require("smart-splits").resize_down(2) end,
          desc = "Resize split down",
        },
        ["<Left>"] = {
          function() require("smart-splits").resize_left(2) end,
          desc = "Resize split left",
        },
        ["<Right>"] = {
          function() require("smart-splits").resize_right(2) end,
          desc = "Resize split right",
        },
        [","] = {
          "@@",
          desc = "Replay last used macro",
        },
        ["<leader>b"] = { name = "Buffer" },
        L = {
          function() require("astrocore.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
          desc = "Next buffer",
        },
        H = {
          function() require("astrocore.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
          desc = "Previous buffer",
        },
        ["<leader>c"] = {
          function()
            local bufs = vim.fn.getbufinfo { buflisted = true }
            require("astrocore.buffer").close()
            if require("astrocore").is_available "alpha-nvim" and not bufs[2] then require("alpha").start(true) end
          end,
          desc = "Close buffer",
        },
        -- navigate buffer tabs with `H` and `L`
        -- L = {
        --   function() require("astrocore.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
        --   desc = "Next buffer",
        -- },
        -- H = {
        --   function() require("astrocore.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
        --   desc = "Previous buffer",
        -- },

        -- mappings seen under group name "Buffer"
        ["<Leader>bD"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Pick to close",
        },
        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        ["<Leader>b"] = { desc = "Buffers" },
        -- quick save
        -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
      },
      t = {
        ["<c-q>"] = { "<c-\\><c-n>", desc = "Terminal normal mode" },
        ["<esc><esc>"] = { "<c-\\><c-n>:q<cr>", desc = "Terminal quit" },
      },
    },
    autocmds = {
      elixir_coverage = {
        cond = "elixir",
        {
          event = "FileType",
          pattern = "elixir",
          desc = "Load lcov Coverage for Elixir",
          callback = function() require("coverage").load_lcov() end,
        },
      },
    },
  },
}
