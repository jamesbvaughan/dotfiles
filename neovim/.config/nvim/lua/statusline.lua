-- luacheck: globals vim
local lualine = require("lualine")

lualine.setup({
	options = {
		theme = "dracula-nvim",
		section_separators = "",
		component_separators = "",
		globalstatus = true,
	},
	extensions = {
		"quickfix",
		"fugitive",
	},
	sections = {
		lualine_a = {
			{
				"mode",
				fmt = function(str)
					return str:sub(1, 1)
				end,
			},
		},
		lualine_b = {
			"branch",
		},
		lualine_c = {
			"filename",
			"diff",
      "lsp_progress"
		},
		lualine_x = {
			{
				"diagnostics",
				sources = { "nvim_diagnostic" },
			},
		},
		lualine_y = {
			{
				"filetype",
				icon_only = true,
			},
			"location",
		},
		lualine_z = {
		},
	},
})
