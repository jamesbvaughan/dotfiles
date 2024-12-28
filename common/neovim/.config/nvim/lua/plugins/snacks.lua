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
		indent = {
			-- Disabled for now because the default highlight is too intense for my
			-- taste.
			enabled = false,
			animate = { enabled = false },
		},
		input = { enabled = true },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		statuscolumn = { enabled = true },
		toggle = { enabled = true },
		words = {
			-- Disabled because it seemed to really slow things down when hovering
			-- symbols.
			enabled = false,
		},
	},
	keys = {
		{
			"gh",
			function()
				Snacks.gitbrowse.open()
			end,
			desc = "Open the current file on the web",
		},
	},
}
