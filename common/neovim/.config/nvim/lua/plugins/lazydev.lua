-- Better dev experience for working on these lua nvim config files
--    https://github.com/folke/lazydev.nvim

return {
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files

		---@type lazydev.Config
		opts = {
			-- Load these plugin libraries explicitly so that they're available in the
			-- relevant plugin config files even if they're not explicitly imported.
			library = {
				"LazyDev",
				"lazydev.nvim",
				"auto-dark-mode.nvim",
				"catppuccin",
				"copilot.lua",
				"diffview.nvim",
				"snacks.nvim",
				"gitsigns.nvim",
				"neogit",
			},
		},
	},
}
