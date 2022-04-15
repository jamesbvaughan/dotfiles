-- luacheck: globals vim
local lsp_status = require("lsp-status")
local lualine = require("lualine")

lsp_status.config({
	show_filename = true,
})

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
			lsp_status.status,
		},
	},
})
