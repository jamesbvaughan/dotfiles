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
	},
}
