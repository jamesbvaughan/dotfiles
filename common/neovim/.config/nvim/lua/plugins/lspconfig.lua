return {
	-- github copilot
	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		config = true,

		---@type copilot_config
		-- opts = {
		-- 	suggestion = { enabled = false },
		-- 	panel = { enabled = false },
		-- },
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		cmd = { "LspInfo", "LspInstall", "LspUninstall" },

		dependencies = {
			{
				"williamboman/mason.nvim",
				config = true,
			},
			"williamboman/mason-lspconfig.nvim",

			-- Pull JSON schemas from SchemaStore for use with jsonls
			"b0o/schemastore.nvim",

			-- UI for loaders
			{
				"j-hui/fidget.nvim",
				opts = {
					notification = {
						window = {
							winblend = 0,
						},
					},
				},
			},

			-- Specific language support
			{
				"pmizio/typescript-tools.nvim",
				dependencies = {
					"nvim-lua/plenary.nvim",
				},
				ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
			},
		},
		init = function()
			-- Reserve a space in the gutter
			-- This will avoid an annoying layout shift in the screen
			vim.opt.signcolumn = "yes"
		end,
		config = function()
			local lspconfig = require("lspconfig")
			local blink = require("blink.cmp")

			-- Add cmp_nvim_lsp capabilities settings to lspconfig
			-- This should be executed before you configure any language server
			lspconfig.util.default_config.capabilities =
				blink.get_lsp_capabilities(lspconfig.util.default_config.capabilities)

			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					local opts = { buffer = event.buf }

					vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
					vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
					vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
					vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
					vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
					vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
					vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)

					vim.keymap.set(
						"n",
						"<leader>ca",
						vim.lsp.buf.code_action,
						vim.tbl_extend("force", opts, { desc = "Show available code actions" })
					)

					-- vim.keymap.set("n", "gd", function()
					-- 	require("telescope.builtin").lsp_definitions(require("telescope.themes").get_cursor())
					-- end, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
					--
					-- vim.keymap.set("n", "go", function()
					-- 	require("telescope.builtin").lsp_type_definitions(require("telescope.themes").get_cursor())
					-- end, vim.tbl_extend("force", opts, { desc = "Go to type definition" }))
				end,
			})

			---@diagnostic disable-next-line: missing-fields
			require("mason-lspconfig").setup({
				ensure_installed = {
					"bashls",
					"cssls",
					"eslint",
					"graphql",
					"html",
					"jsonls",
					"prismals",
					"pyright",
					"lua_ls",
					"tailwindcss",
					"taplo",
					"terraformls",
					"tflint",
					"ts_ls",
					"yamlls",
				},
				handlers = {
					-- this first function is the "default handler"
					-- it applies to every language server without a "custom handler"
					function(server_name)
						require("lspconfig")[server_name].setup({})
					end,
					lua_ls = function()
						lspconfig.lua_ls.setup({
							settings = {
								Lua = {
									diagnostics = {
										unusedLocalExclude = { "_*" },
									},
								},
							},
						})
					end,
					jsonls = function()
						lspconfig.jsonls.setup({
							settings = {
								json = {
									schemas = require("schemastore").json.schemas(),
									validate = { enable = true },
								},
							},
						})
					end,
					cssls = function()
						lspconfig.cssls.setup({
							settings = {
								scss = {
									lint = {
										unknownAtRules = "ignore",
									},
								},
							},
						})
					end,
					yamlls = function()
						lspconfig.yamlls.setup({
							settings = {
								yaml = {
									schemastore = {
										enable = true,
									},
								},
							},
						})
					end,
					eslint = function()
						lspconfig.eslint.setup({
							capabilities = {
								document_formatting = false,
								document_range_formatting = false,
							},
							settings = {
								codeActionOnSave = {
									enable = true,
								},
								-- Disable some rules to speed up lint results.
								-- These still run in pre-commit hooks and in CI.
								rulesCustomizations = {
									{ rule = "@typescript-eslint/no-misused-promises", severity = "off" },
									{ rule = "@typescript-eslint/no-unsafe-argument", severity = "off" },
									{ rule = "@typescript-eslint/no-unsafe-assignment", severity = "off" },
									{ rule = "import/defaults", severity = "off" },
									{ rule = "import/extensions", severity = "off" },
									{ rule = "import/namespace", severity = "off" },
									{ rule = "import/no-cycle", severity = "off" },
									{ rule = "import/no-unresolved", severity = "off" },

									-- Disable some rules that conflict with tsserver warnings
									{ rule = "unused-imports/no-unused-vars", severity = "off" },
								},

								experimental = {},
							},
						})
					end,
					ts_ls = function()
						lspconfig.ts_ls.setup({
							settings = {
								expose_as_code_action = "all",

								typescript = {
									inlayHints = {
										-- includeInlayParameterNameHints: 'none' | 'literals' | 'all';
										includeInlayParameterNameHints = "all",
										includeInlayParameterNameHintsWhenArgumentMatchesName = true,
										includeInlayFunctionParameterTypeHints = true,
										includeInlayVariableTypeHints = true,
										includeInlayVariableTypeHintsWhenTypeMatchesName = true,
										includeInlayPropertyDeclarationTypeHints = true,
										includeInlayFunctionLikeReturnTypeHints = true,
										includeInlayEnumMemberValueHints = true,
									},
								},
							},
						})
					end,
					rust_analyzer = function() end,
				},
			})

			local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end
		end,
	},

	-- Rust LSP
	{
		"mrcjkb/rustaceanvim",
		version = "^5",
		ft = { "rust" },
	},

	-- Better inline diagnostic styling
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "LspAttach",
		init = function()
			vim.diagnostic.config({ virtual_text = false })
		end,
		opts = {
			preset = "simple",
		},
	},

	-- Error window
	{
		"folke/trouble.nvim",
		event = "VeryLazy",
	},
}
