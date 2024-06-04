return {
	{
		"folke/trouble.nvim",
		dependencies = {
			"kyazdani42/nvim-web-devicons",
		},
		keys = {
			-- { "<leader>q", ":TroubleToggle<cr>" },
			-- {
			-- 	"<leader>q",
			-- 	"<cmd>Trouble diagnostics toggle<cr>",
			-- 	desc = "Diagnostics (Trouble)",
			-- },

			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},

		opts = {
			-- auto_close = true,
			-- auto_open = true,
			-- auto_preview = false,
			-- height = 5,
			-- mode = "document_diagnostics",
			-- group = false,
			-- padding = false,
			-- indent_lines = false,
		},
	},
}
