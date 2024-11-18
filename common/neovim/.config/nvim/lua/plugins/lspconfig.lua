return {
	-- Pull JSON schemas from SchemsStore for use with jsonls
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
		"L3MON4D3/LuaSnip",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		lazy = true,
		build = "make install_jsregexp",
		config = function(_, opts)
			if opts then
				require("luasnip").config.setup(opts)
			end
			vim.tbl_map(function(type)
				require("luasnip.loaders.from_" .. type).lazy_load()
			end, { "vscode", "snipmate", "lua" })
			-- friendly-snippets - enable standardized comments snippets
			require("luasnip").filetype_extend("typescript", { "tsdoc" })
			require("luasnip").filetype_extend("javascript", { "jsdoc" })
			require("luasnip").filetype_extend("lua", { "luadoc" })
			require("luasnip").filetype_extend("python", { "pydoc" })
			require("luasnip").filetype_extend("rust", { "rustdoc" })
			require("luasnip").filetype_extend("cs", { "csharpdoc" })
			require("luasnip").filetype_extend("java", { "javadoc" })
			require("luasnip").filetype_extend("c", { "cdoc" })
			require("luasnip").filetype_extend("cpp", { "cppdoc" })
			require("luasnip").filetype_extend("php", { "phpdoc" })
			require("luasnip").filetype_extend("kotlin", { "kdoc" })
			require("luasnip").filetype_extend("ruby", { "rdoc" })
			require("luasnip").filetype_extend("sh", { "shelldoc" })
		end,
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

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		enabled = true,
		dependencies = {
			{ "L3MON4D3/LuaSnip" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-cmdline" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "hrsh7th/cmp-path" },
			{ "onsails/lspkind-nvim" },
			{ "petertriho/cmp-git" },
			{ "saadparwaiz1/cmp_luasnip" },
			{
				"zbirenbaum/copilot-cmp",
				event = "InsertEnter",
				config = true,
			},
		},
		config = function()
			require("../completion")
		end,
	},
	{
		"saghen/blink.cmp",
		enabled = false,
		lazy = false, -- lazy loading handled internally
		dependencies = "rafamadriz/friendly-snippets",
		version = "v0.*",
		opts = {
			highlight = {
				-- sets the fallback highlight groups to nvim-cmp's highlight groups
				-- useful for when your theme doesn't support blink.cmp
				-- will be removed in a future release, assuming themes add support
				use_nvim_cmp_as_default = true,
			},

			windows = {
				documentation = {
					auto_show = true,
				},
			},
		},
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
}
