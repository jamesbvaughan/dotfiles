-- Plugins related to the Neovim UI
--
return {
	-- Override the default input and select menu styling
	--   https://github.com/stevearc/dressing.nvim
	{ "stevearc/dressing.nvim", event = "VeryLazy" },

	-- Show a fancy buffer line
	--   https://github.com/akinsho/bufferline.nvim
	{
		"akinsho/bufferline.nvim",
		dependencies = "kyazdani42/nvim-web-devicons",
		event = "VeryLazy",
		opts = {
			options = {
				show_buffer_close_icons = false,
				show_close_icon = false,
				always_show_bufferline = false,
				diagnostics = "nvim_lsp",
			},
		},
	},

	-- Give hints for keymaps
	--   https://github.com/folke/which-key.nvim
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		dependencies = { { "echasnovski/mini.icons", config = true } },
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
			require("which-key").setup()
		end,
	},

	-- Highlight TODOs
	--   https://github.com/folke/todo-comments.nvim
	{
		"folke/todo-comments.nvim",
		event = "VeryLazy",
		opts = {},
	},

	-- Highlight real colors inside nvim (example: #920565)
	--   https://github.com/brenoprata10/nvim-highlight-colors
	{
		"brenoprata10/nvim-highlight-colors",
		event = "VeryLazy",
		opts = {
			enable_tailwind = true,
		},
	},

	-- Add a label for the current file name
	--   https://github.com/b0o/incline.nvim
	{
		"b0o/incline.nvim",
		event = "VeryLazy",
		opts = {
			window = { margin = { vertical = 0, horizontal = 1 } },
			render = function(props)
				local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
				local icon, color = require("nvim-web-devicons").get_icon_color(filename)
				return { { icon, guifg = color }, { " " }, { filename } }
			end,
			hide = {
				only_win = true,
			},
		},
	},

	-- Highlight the hovered symbol
	--   https://github.com/RRethy/vim-illuminate
	{
		"RRethy/vim-illuminate",
		event = "CursorHold",
		config = function()
			require("illuminate").configure({
				delay = 0,
				under_cursor = false,
				filetypes_denylist = {
					"dirvish",
					"fugitive",
					"TelescopePrompt",
					"NeogitStatus",
				},
			})
		end,
	},
}
