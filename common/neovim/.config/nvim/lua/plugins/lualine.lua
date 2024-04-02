return {
	{
		"hoob3rt/lualine.nvim",
		dependencies = {
			"kyazdani42/nvim-web-devicons",
		},
		opts = {
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
					{
						"filename",
						path = 1,
					},
				},
				lualine_x = {
					"filetype",
					{
						require("lazy.status").updates,
						cond = require("lazy.status").has_updates,
						color = { fg = "#ff9e64" },
					},
				},
			},
		},
	},
}
