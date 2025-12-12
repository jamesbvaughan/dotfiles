return {
	{
		"nvim-mini/mini.nvim",
		version = "*",
		event = "VeryLazy",
		config = function()
			-- Alignment utilities
			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-align.md
			-- I haven't quite gotten the hang of this yet, but it seems like it could
			-- be really useful.
			-- require("mini.align").setup()
			require("mini.icons").setup()
		end,
	},
}
