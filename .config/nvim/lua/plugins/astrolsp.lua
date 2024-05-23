-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- Configuration table of features provided by AstroLSP
    features = {
      autoformat = true, -- enable or disable auto formatting on start
      codelens = true, -- enable/disable codelens refresh on start
      inlay_hints = false, -- enable/disable inlay hints on start
      semantic_tokens = true, -- enable/disable semantic token highlighting
    },
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
          "markdown",
        },
      },
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
      --
      disabled = { "sumneko_lua", "rust_analyzer" },
      timeout_ms = 5000,
      filter = function(client)
        -- only enable null-ls for some filetypes
        local null_ls_only = {
          "javascript", -- use prettier
          "typescript", -- use prettier
          "javascriptreact", -- use prettier
          "typescriptreact", -- use prettier
          "elixir", -- use mix
          "rust", -- use rustfmt
          "lua", -- use stylua
        }
        if vim.tbl_contains(null_ls_only, vim.bo.filetype) then return client.name == "null-ls" end

        -- enable all other clients
        return true
      end,
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- "lexical"
    },
    -- customize language server configuration options passed to `lspconfig`
    ---@diagnostic disable: missing-fields
    config = {
      -- clangd = { capabilities = { offsetEncoding = "utf-8" } },
      html = {
        filetypes = { "html", "heex" },
      },
      yamlls = {
        settings = {
          yaml = {
            schemas = {
              ["https://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
              ["https://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
              ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose.*.{yml,yaml}",
              ["https://json.schemastore.org/traefik-v2"] = "traefik.{yml,yaml}",
            },
          },
        },
      },
    },
    -- customize how language servers get set up
    handlers = {
      -- a function without a key is simply the default handler, functions take two parameters, the server name and the configured options table for that server
      function(server, opts) require("lspconfig")[server].setup(opts) end,
      lexical = function(_, _)
        local lspconfig = require "lspconfig"
        local configs = require "lspconfig.configs"

        local lexical_config = {
          filetypes = { "elixir", "eelixir", "heex" },
          cmd = { "/Users/cfb/code/github/lexical/_build/dev/package/lexical/bin/start_lexical.sh" },
          settings = {},
        }

        if not configs.lexical then
          configs.lexical = {
            default_config = {
              filetypes = lexical_config.filetypes,
              cmd = lexical_config.cmd,
              root_dir = function(fname)
                return lspconfig.util.root_pattern("mix.exs", ".git")(fname) or vim.loop.os_homedir()
              end,
              -- optional settings
              settings = lexical_config.settings,
            },
          }
        end

        lspconfig.lexical.setup {}
      end,
      -- the key is the server that is being setup with `lspconfig`
      -- rust_analyzer = false, -- setting a handler to false will disable the set up of that language server
      -- pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end -- or a custom handler function can be passed
    },
    -- Configure buffer local auto commands to add when attaching a language server
    autocmds = {
      -- first key is the `augroup` to add the auto commands to (:h augroup)
      lsp_document_highlight = {
        -- Optional condition to create/delete auto command group
        -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
        -- condition will be resolved for each client on each execution and if it ever fails for all clients,
        -- the auto commands will be deleted for that buffer
        cond = "textDocument/documentHighlight",
        -- cond = function(client, bufnr) return client.name == "lua_ls" end,
        -- list of auto commands to set
        {
          -- events to trigger
          event = { "CursorHold", "CursorHoldI" },
          -- the rest of the autocmd options (:h nvim_create_autocmd)
          desc = "Document Highlighting",
          callback = function() vim.lsp.buf.document_highlight() end,
        },
        {
          event = { "CursorMoved", "CursorMovedI", "BufLeave" },
          desc = "Document Highlighting Clear",
          callback = function() vim.lsp.buf.clear_references() end,
        },
      },
    },
    -- mappings to be set up on attaching of a language server
    mappings = {
      -- first key is the mode
      n = {
        gl = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics" },
      },
    },
    -- A custom `on_attach` function to be run after the default `on_attach` function
    -- takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
    on_attach = function(client, bufnr)
      -- this would disable semanticTokensProvider for all clients
      -- client.server_capabilities.semanticTokensProvider = nil
    end,
  },
}
