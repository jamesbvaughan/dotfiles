-- Better dev experience for working on these lua nvim config files
--    https://github.com/folke/lazydev.nvim

vim.pack.add({ gh("folke/lazydev.nvim") })

---@type lazydev.Config
require("lazydev").setup({
	library = {
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
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
})
