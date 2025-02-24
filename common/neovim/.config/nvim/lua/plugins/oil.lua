-- A nice file browser
--   https://github.com/stevearc/oil.nvim

return {
	{
		"stevearc/oil.nvim",
		event = "VeryLazy",
		opts = {
			keymaps = {
				["q"] = "actions.close",
			},
			win_options = {
				signcolumn = "yes:2",
			},
		},
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{ "-", vim.cmd.Oil },
		},
	},

	{
		"refractalize/oil-git-status.nvim",
		config = true,
		dependencies = {
			"stevearc/oil.nvim",
		},
	},
}
