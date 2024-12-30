return {
	{
		"echasnovski/mini.nvim",
		version = "*",
		event = "VeryLazy",
		-- There are some interesting utilities in here, but I'm not actually using
		-- any at this point. I'm disabling this, but leaving it here in case I want
		-- to revisit it in the future.
		enabled = false,
		config = function()
			-- Alignment utilities
			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-align.md
			-- I haven't quite gotten the hang of this yet, but it seems like it could
			-- be really useful.
			require("mini.align").setup()
		end,
	},
}
