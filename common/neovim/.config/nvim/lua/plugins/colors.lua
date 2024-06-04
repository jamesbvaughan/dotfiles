return {
	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		enabled = false,
		priority = 1000,
		opts = {
			transparent_mode = true,
			overrides = {
				-- SignColumn = { bg = "NONE" },
				-- GruvboxRedSign = { bg = "NONE" },
				-- GruvboxYellowSign = { bg = "NONE" },
				-- GruvboxBlueSign = { bg = "NONE" },
				-- GruvboxAquaSign = { bg = "NONE" },
				-- GruvboxGreenSign = { bg = "NONE" },
				CmpItemKindCopilot = { fg = "#98971A" },
			},
		},
		init = function()
			vim.cmd("colorscheme gruvbox")
		end,
	},

	{
		"hylophile/flatwhite.nvim",
		enabled = false,
		lazy = true,
		opts = {
			transparent_bg = true,
		},
	},

	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			integrations = {
				lsp_trouble = true,
				mason = true,
				which_key = true,
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
					},
					underlines = {
						errors = { "undercurl" },
						hints = { "underline" },
						warnings = { "underline" },
						information = { "underline" },
					},
					inlay_hints = {
						background = false,
					},
				},
			},
		},
		init = function()
			vim.cmd("colorscheme catppuccin")
		end,
	},

	{
		"f-person/auto-dark-mode.nvim",
		lazy = false,
	},
}
