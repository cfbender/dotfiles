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
			codelens = true,     -- enable/disable codelens refresh on start
			inlay_hints = true,  -- enable/disable inlay hints on start
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
			disabled = { "sumneko_lua", "rust_analyzer", "prettier" },
			timeout_ms = 5000,
		},
		-- enable servers that you already have installed without mason
		servers = {
			-- "pyright"
		},
		-- customize language server configuration options passed to `lspconfig`
		---@diagnostic disable: missing-fields
		config = {
			-- clangd = { capabilities = { offsetEncoding = "utf-8" } },
			vtsls = {
				settings = {
					typescript = {
						inlayHints = {
							parameterNames = { enabled = "literals" },
							parameterTypes = { enabled = false },
							propertyDeclarationTypes = { enabled = true },
							functionLikeReturnTypes = { enabled = false },
							enumMemberValues = { enabled = true },
							variableTypes = { enabled = false },
						},
					},
				},
			},
			html = {
				filetypes = { "html", "heex" },
			},
			yamlls = {
				settings = {
					yaml = {
						schemas = {
							["https://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
							["https://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
							["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
							"docker-compose.*.{yml,yaml}",
							["https://json.schemastore.org/traefik-v2"] = "traefik.{yml,yaml}",
						},
					},
				},
			},
		},
		-- customize how language servers are attached
		handlers = {
			-- a function without a key is simply the default handler, functions take two parameters, the server name and the configured options table for that server
			-- function(server, opts)
			-- 	require("lspconfig")[server].setup(opts)
			-- end,
			-- the key is the server that is being setup with `lspconfig`
			-- rust_analyzer = false, -- setting a handler to false will disable the set up of that language server
			-- pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end -- or a custom handler function can be passed
			-- lexical = function(_, _)
			-- 	local lspconfig = require("lspconfig")
			-- 	local configs = require("lspconfig.configs")
			--
			-- 	local lexical_config = {
			-- 		filetypes = { "elixir", "eelixir", "heex" },
			-- 		cmd = { "/Users/cfb/code/github/lexical/_build/dev/package/lexical/bin/start_lexical.sh" },
			-- 		settings = {},
			-- 	}
			--
			-- 	if not configs.lexical then
			-- 		configs.lexical = {
			-- 			default_config = {
			-- 				filetypes = lexical_config.filetypes,
			-- 				cmd = lexical_config.cmd,
			-- 				root_dir = function(fname)
			-- 					return lspconfig.util.root_pattern("mix.exs", ".git")(fname) or vim.loop.os_homedir()
			-- 				end,
			-- 				-- optional settings
			-- 				settings = lexical_config.settings,
			-- 			},
			-- 		}
			-- 	end
			--
			-- 	lspconfig.lexical.setup({})
			-- end,
		},
		-- Configure buffer local auto commands to add when attaching a language server
		autocmds = {
			-- first key is the `augroup` to add the auto commands to (:h augroup)
			lsp_codelens_refresh = {
				-- Optional condition to create/delete auto command group
				-- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
				-- condition will be resolved for each client on each execution and if it ever fails for all clients,
				-- the auto commands will be deleted for that buffer
				cond = "textDocument/codeLens",
				-- cond = function(client, bufnr) return client.name == "lua_ls" end,
				-- list of auto commands to set
				{
					-- events to trigger
					event = { "InsertLeave", "BufEnter" },
					-- the rest of the autocmd options (:h nvim_create_autocmd)
					desc = "Refresh codelens (buffer)",
					callback = function(args)
						if require("astrolsp").config.features.codelens then
							vim.lsp.codelens.refresh({ bufnr = args.buf })
						end
					end,
				},
			},
		},
		-- mappings to be set up on attaching of a language server
		mappings = {
			n = {
				-- a `cond` key can provided as the string of a server capability to be required to attach, or a function with `client` and `bufnr` parameters from the `on_attach` that returns a boolean
				gD = {
					function()
						vim.lsp.buf.declaration()
					end,
					desc = "Declaration of current symbol",
					cond = "textDocument/declaration",
				},
				["<Leader>uY"] = {
					function()
						require("astrolsp.toggles").buffer_semantic_tokens()
					end,
					desc = "Toggle LSP semantic highlight (buffer)",
					cond = function(client)
						return client.supports_method("textDocument/semanticTokens/full")
								and vim.lsp.semantic_tokens ~= nil
					end,
				},
				grr = {
					function()
						require("snacks.picker").lsp_references()
					end,
					desc = "LSP References",
					cond = function(client, bufnr)
						return client.server_capabilities.referencesProvider ~= nil
								and vim.api.nvim_buf_is_loaded(bufnr) -- ensure the buffer is loaded
					end,
				},
				gI = {
					function()
						require("snacks").picker.lsp_implementations({
							filter = {
								filter = function(item)
									-- exclude defdelegates from results, so we can jump directly to the
									-- real impl
									return not item.text:match("defdelegate")
								end,
							},
						})
					end,
					desc = "LSP Implementations",
					cond = "textDocument/implementation",
				},
				gd = {
					function()
						require("snacks.picker").lsp_definitions()
					end,
					desc = "LSP Definitions",
					cond = "textDocument/definition",
				},
				gy = {
					function()
						require("snacks.picker").lsp_type_definitions()
					end,
					desc = "LSP Type Definitions",
					cond = "textDocument/typeDefinition",
				},
				["<Leader>lG"] = {
					function()
						require("snacks.picker").lsp_workspace_symbols()
					end,
					desc = "LSP Workspace Symbols",
					cond = "workspace/symbol",
				},
				["<Leader>lR"] = {
					function()
						require("snacks.picker").lsp_references()
					end,
					desc = "LSP References (workspace)",
					cond = "workspace/references",
				},
			},
		},
		-- A custom `on_attach` function to be run after the default `on_attach` function
		-- takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
		-- on_attach = function(client, bufnr)
		-- 	require("snacks.notify").info("AstroLSP: attaching " .. client.name, { title = "LSP", timeout = 3000 })
		-- end,
	},
}
