-- A nice git interface
--   https://github.com/NeogitOrg/neogit

return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"sindrets/diffview.nvim",
	},
	keys = {
		{ "<leader>g", vim.cmd.Neogit, desc = "Open neogit" },
	},

	---@type NeogitConfig
	opts = {
		disable_hint = true,
		disable_insert_on_commit = false,
		graph_style = "unicode",
		signs = {
			-- { CLOSED, OPENED }
			hunk = { "", "" },
			item = { "▶", "▼" },
			section = { "▶", "▼" },
		},
		telescope_sorter = function()
			return require("telescope").extensions.fzy_native.fzy_sorter
		end,
		integrations = {
			telescope = false,
		},
	},
}
