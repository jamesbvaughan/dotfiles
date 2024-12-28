return {
	-- Pull JSON schemas from SchemaStore for use with jsonls
	"b0o/schemastore.nvim",

	-- github copilot
	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		config = true,
		-- opts = {
		-- 	suggestion = { enabled = false },
		-- 	panel = { enabled = false },
		-- },
	},

	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v4.x",
		lazy = true,
		config = false,
		init = function()
			-- Disable automatic setup, we are doing it manually
			vim.g.lsp_zero_extend_cmp = 0
			vim.g.lsp_zero_extend_lspconfig = 0
		end,
	},
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = true,
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "williamboman/mason-lspconfig.nvim" },

			-- UI for loaders
			{
				"j-hui/fidget.nvim",
				tag = "legacy",
				opts = {
					text = {
						spinner = "circle_halves",
					},
				},
			},

			-- Additional lua configuration
			"folke/neodev.nvim",

			-- Specific language support
			{
				"pmizio/typescript-tools.nvim",
				dependencies = {
					"nvim-lua/plenary.nvim",
				},
			},
			"simrat39/rust-tools.nvim",

			-- Error window
			"folke/trouble.nvim",
		},
		config = function()
			require("../lsp")
		end,
	},

	-- Rust LSP
	{
		"mrcjkb/rustaceanvim",
		version = "^4",
		ft = { "rust" },
	},

	-- Better inline diagnostic styling
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy", -- Or `LspAttach`
		priority = 1000, -- needs to be loaded in first
		config = function()
			vim.diagnostic.config({ virtual_text = false })
			require("tiny-inline-diagnostic").setup({
				preset = "simple",
			})
		end,
	},
}
