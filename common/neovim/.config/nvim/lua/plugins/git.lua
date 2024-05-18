return {
	{
		"tpope/vim-fugitive",
		lazy = false,
		dependencies = "tpope/vim-rhubarb",
		keys = {
			{
				"gh",
				vim.cmd.GBrowse,
				desc = "Open the current file in GitHub",
			},
			{ "gl", ":Git log --pretty --oneline --abbrev-commit --graph -20 <cr>" },
		},
	},

	{
		"lewis6991/gitsigns.nvim",
		opts = {
			current_line_blame = true,
			current_line_blame_opts = {
				ignore_whitespace = true,
				delay = 500,
			},
		},
	},

	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{ "<leader>g", vim.cmd.Neogit, desc = "Open neogit" },
		},
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
				return require("telescope").extensions.fzf.native_fzf_sorter()
			end,
		},
	},

	{
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
		opts = {
			enhanced_diff_hl = true,
		},
	},
}
