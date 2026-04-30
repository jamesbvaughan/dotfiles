vim.pack.add({
	gh("kyazdani42/nvim-web-devicons"),
	gh("hoob3rt/lualine.nvim"),
})

require("lualine").setup({
	options = {
		section_separators = "",
		component_separators = "",
		globalstatus = true,
	},
	extensions = {
		"oil",
		"quickfix",
		"trouble",
	},
	sections = {
		lualine_c = {
			{
				"filename",
				path = 1,
			},
		},
		lualine_x = {
			"lsp_status",
			"filetype",
		},
	},
})
