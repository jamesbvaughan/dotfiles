local function setDark()
	vim.opt.background = "dark"
	vim.cmd("colorscheme catppuccin")
end

local function setLight()
	vim.opt.background = "light"
	vim.cmd("colorscheme catppuccin")
end

return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,

		---@type CatppuccinOptions
		opts = {
			integrations = {
				blink_cmp = true,
				diffview = true,
				fidget = true,
				lsp_trouble = true,
				mason = true,
				notify = true,
				snacks = true,
				which_key = true,
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
						errors = { "undercurl" },
						hints = { "underline" },
						warnings = { "undercurl" },
						information = { "underline" },
					},
					inlay_hints = {
						background = true,
					},
				},
			},
		},
		init = setDark,
	},

	{
		"f-person/auto-dark-mode.nvim",
		event = "VeryLazy",

		---@type AutoDarkModeOptions
		opts = {
			update_interval = 1000,
			set_dark_mode = setDark,
			set_light_mode = setLight,
		},
	},
}
