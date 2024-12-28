-- Better dev experience for working on these lua nvim config files
--    https://github.com/folke/lazydev.nvim

return {
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				"LazyDev",
				"snacks.nvim",
			},
		},
	},
}
