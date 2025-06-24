return {
	-- LSP
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		cmd = { "LspInfo", "LspInstall", "LspUninstall" },

		dependencies = {
			{
				"mason-org/mason.nvim",
				cmd = { "Mason" },
				config = true,
			},
			"mason-org/mason-lspconfig.nvim",

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
				opts = {
					settings = {
						expose_as_code_action = {
							"add_missing_imports",
							"remove_unused_imports",
						},
						jsx_close_tag = {
							enable = true,
							filetypes = { "javascriptreact", "typescriptreact" },
						},
					},
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

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = {
							unusedLocalExclude = { "_*" },
						},
					},
				},
			})

			vim.lsp.config("jsonls", {
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})

			vim.lsp.config("cssls", {
				settings = {
					css = {
						lint = {
							unknownAtRules = "ignore",
						},
					},
				},
			})

			vim.lsp.config("yamlls", {
				settings = {
					yaml = {
						schemastore = {
							enable = true,
						},
					},
				},
			})

			vim.diagnostic.config({
				-- virtual_lines = {
				-- 	-- Only show virtual line diagnostics for the current line
				-- 	current_line = true,
				-- },
				virtual_lines = false,
			})

			-- Add cmp_nvim_lsp capabilities settings to lspconfig
			-- This should be executed before you configure any language server
			lspconfig.util.default_config.capabilities =
				blink.get_lsp_capabilities(lspconfig.util.default_config.capabilities)

			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					local opts = { buffer = event.buf }

					local function cursor_pick(telescope_builtin_name)
						return function()
							local telescope_builtin = require("telescope.builtin")
							local telescope_themes = require("telescope.themes")
							local cursor_theme = telescope_themes.get_cursor()
							telescope_builtin[telescope_builtin_name](cursor_theme)
						end
					end

					vim.keymap.set(
						"n",
						"grr",
						cursor_pick("lsp_references"),
						vim.tbl_extend("force", opts, { desc = "Go to references" })
					)

					vim.keymap.set(
						"n",
						"gi",
						cursor_pick("lsp_implementations"),
						vim.tbl_extend("force", opts, { desc = "Go to implementation" })
					)

					vim.keymap.set(
						"n",
						"gd",
						cursor_pick("lsp_definitions"),
						vim.tbl_extend("force", opts, { desc = "Go to definition" })
					)

					vim.keymap.set(
						"n",
						"go",
						cursor_pick("lsp_type_definitions"),
						vim.tbl_extend("force", opts, { desc = "Go to type definition" })
					)

					vim.keymap.set(
						"n",
						"<leader>fe",
						":EslintFixAll<CR>",
						vim.tbl_extend("force", opts, { desc = "Run ESLint auto-fixes" })
					)
				end,
			})

			require("mason-lspconfig").setup({
				ensure_installed = {
					"bashls",
					"cssls",
					"eslint",
					"html",
					"jsonls",
					"pyright",
					"lua_ls",
					"oxlint",
					"tailwindcss",
					"taplo",
					"terraformls",
					"tflint",
					"ts_ls",
					"yamlls",
				},
				automatic_enable = {
					exclude = { "ts_ls", "eslint", "rust_analyzer" },
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
		lazy = false,
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
