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
	init = function()
		local Snacks = require("snacks")
		-- Reference for more toggle ideas:
		--   https://www.reddit.com/r/neovim/comments/1j55o9c/share_your_custom_toggles_using_snacks_toggle/
		Snacks.toggle.option("spell", { name = "󰓆 Spell Checking" }):map("<leader>ts")
		Snacks.toggle.option("wrap", { name = "󰖶 Wrap Long Lines" }):map("<leader>tw")
		Snacks.toggle.option("list", { name = "󱁐 List (Visible Whitespace)" }):map("<leader>tl")
		Snacks.toggle.diagnostics({ name = " Diagnostics" }):map("<leader>tD")
	end,
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
