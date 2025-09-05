return {
	"sindrets/diffview.nvim",
	keys = {
		{
			"<leader>h",
			function()
				vim.cmd.DiffviewFileHistory("%")
			end,
			desc = "Open diffview for the current file",
		},
	},

	---@type DiffviewConfig
	opts = {
		enhanced_diff_hl = true,
		keymaps = {
			-- view = {
			--   { "n", "q", actions.close, { desc = "Close help menu" } },
			-- },
			file_panel = {
				{ "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
			},
			file_history_panel = {
				{ "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
			},
		},
	},
}
