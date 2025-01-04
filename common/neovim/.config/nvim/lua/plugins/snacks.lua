-- Config for snacks.nvim
--   https://github.com/folke/snacks.nvim

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,

	---@type snacks.Config
	opts = {
		bufdelete = { enabled = true },
		gitbrowse = { enabled = true },
		indent = { enabled = true, animate = { enabled = false } },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		statuscolumn = { enabled = true },
		toggle = { enabled = true },
	},
	keys = {
		{
			"<leader>d",
			function()
				require("snacks").bufdelete()
			end,
			desc = "Close the current buffer",
		},
		{
			"<leader>n",
			function()
				require("snacks").notifier.show_history()
			end,
			desc = "Show notification history",
		},
		{
			"gh",
			function()
				require("snacks").gitbrowse.open()
			end,
			desc = "Open the current file on the web",
		},
	},
}
