local function setDark()
	vim.opt.background = "dark"
	vim.cmd("colorscheme catppuccin")
end

local function setLight()
	vim.opt.background = "light"
	vim.cmd("colorscheme catppuccin")
end

vim.pack.add({
	{ src = gh("catppuccin/nvim"), name = "catppuccin" },
	gh("f-person/auto-dark-mode.nvim"),
})

---@type CatppuccinOptions
require("catppuccin").setup({
	integrations = {
		blink_cmp = true,
		diffview = true,
		fidget = true,
		lsp_trouble = true,
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
	custom_highlights = function(colors)
		return {
			SnacksIndent = { fg = colors.surface0 },
			SnacksIndentScope = { fg = colors.surface2 },
			BlinkCmpMenu = { bg = colors.mantle },
		}
	end,
})

setDark()

---@type AutoDarkModeOptions
require("auto-dark-mode").setup({
	update_interval = 1000,
	set_dark_mode = setDark,
	set_light_mode = setLight,
})
