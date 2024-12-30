local telescope_builtin = function(name, opts)
	return function()
		local ivy = require("telescope.themes").get_ivy
		require("telescope.builtin")[name](ivy(opts))
	end
end

local function smart_open()
	local ivy = require("telescope.themes").get_ivy()
	require("telescope").extensions.smart_open.smart_open(ivy)
end

return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{
				"danielfalk/smart-open.nvim",
				branch = "0.2.x",
				dependencies = {
					"kkharji/sqlite.lua",
					"nvim-telescope/telescope-fzy-native.nvim",
				},
			},
		},
		keys = {
			{
				"<leader>ff",
				telescope_builtin("find_files"),
				desc = "Find files",
			},
			{
				"<leader>fg",
				telescope_builtin("live_grep"),
				desc = "Live grep",
			},
			{
				"<leader>fb",
				telescope_builtin("buffers"),
				desc = "Search open buffers",
			},
			{
				"<leader>fa",
				telescope_builtin("git_files", { show_untracked = true }),
				desc = "Find files in current git repo",
			},
			{
				"<leader><leader>",
				smart_open,
				desc = "Smart file/buffer search",
			},
			{
				"<leader>fs",
				telescope_builtin("grep_string"),
				desc = "Search for the word under the cursor",
			},
			{
				"<leader>ft",
				telescope_builtin("treesitter"),
				desc = "Search treesitter symbols",
			},
			{
				"<leader>fc",
				telescope_builtin("git_files", {
					cwd = "~/.dotfiles",
					show_untracked = true,
				}),
				desc = "Search dotfiles repo",
			},
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<esc>"] = actions.close,
						},
					},
				},
				extensions = {
					fzf = {},
				},
			})

			-- telescope.load_extension("fzf")
			telescope.load_extension("fzy_native")
			telescope.load_extension("smart_open")
		end,
	},
}
