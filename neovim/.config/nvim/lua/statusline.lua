-- luacheck: globals vim
local lualine = require("lualine")

lualine.setup({
	options = {
		section_separators = "",
		component_separators = "",
		globalstatus = true,
	},
	extensions = {
		"quickfix",
		"fugitive",
	},
	sections = {
		lualine_c = {
			"filename",
      "lsp_progress"
		},
		lualine_x = {
      "filetype",
		},
	},
})
