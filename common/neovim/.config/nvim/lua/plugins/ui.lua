-- Plugins related to the Neovim UI
--
return {
	-- Override the default input and select menu styling
	{ "stevearc/dressing.nvim", event = "VeryLazy" },

	-- Show a fancy buffer line
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
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		dependencies = { "echasnovski/mini.nvim" },
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
			require("which-key").setup()
		end,
	},

	-- Highlight TODOs
	{
		"folke/todo-comments.nvim",
		event = "VeryLazy",
		opts = {},
	},

	-- Visualize indentation
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "VeryLazy",
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		opts = {
			scope = { enabled = false },
		},
	},

	-- Highlight real colors inside nvim (example: #920565)
	{
		"brenoprata10/nvim-highlight-colors",
		event = "VeryLazy",
		opts = {
			enable_tailwind = true,
		},
	},

	-- Add a label for the current file name
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
				only_win = true, -- Hide incline if only one window in tab
			},
		},
	},

	-- Highlight the hovered symbol
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
