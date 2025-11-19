-- A nice git interface
--   https://github.com/NeogitOrg/neogit

return {
	"NeogitOrg/neogit",

	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
	},

	keys = {
		{
			"<leader>g",
			function()
				local neogit = require("neogit")
				-- neogit.open({ kind = "floating" })
				neogit.open()
			end,
			desc = "Open neogit",
		},
	},

	---@type NeogitConfig
	opts = {
		disable_hint = true,
		disable_insert_on_commit = false,
		graph_style = "kitty",
		signs = {
			-- { CLOSED, OPENED }
			hunk = { "", "" },
			item = { "▶", "▼" },
			section = { "▶", "▼" },
		},
	},
}
