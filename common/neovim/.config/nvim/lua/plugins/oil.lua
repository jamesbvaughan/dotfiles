-- A nice file browser
--   https://github.com/stevearc/oil.nvim

return {
	"stevearc/oil.nvim",
	event = "VeryLazy",
	opts = {
		keymaps = {
			["q"] = "actions.close",
		},
	},
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{ "-", vim.cmd.Oil },
	},
}
