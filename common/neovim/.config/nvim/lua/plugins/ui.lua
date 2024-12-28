-- Plugins related to the Neovim UI
--
return {
	-- Override the default input and select menu styling
	"stevearc/dressing.nvim",

	-- Show a fancy buffer line
	{
		"akinsho/bufferline.nvim",
		dependencies = "kyazdani42/nvim-web-devicons",
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
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
			require("which-key").setup()
		end,
	},

	-- Highlight TODOs
	{
		"folke/todo-comments.nvim",
		opts = {},
	},

	-- Visualize indentation
	{
		"lukas-reineke/indent-blankline.nvim",
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
		opts = {
			enable_tailwind = true,
		},
	},

	-- Add a label for the current file name
	{
		"b0o/incline.nvim",
		config = function()
			-- local colors = require("gruvbox.palette")

			require("incline").setup({
				highlight = {
					groups = {
						-- TODO: Find out why these stopped working
						-- InclineNormal = { guibg = colors.dark2, guifg = colors.light0 },
						-- InclineNormalNC = { guibg = colors.dark1, guifg = colors.gray },
					},
				},
				window = { margin = { vertical = 0, horizontal = 1 } },
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					local icon, color = require("nvim-web-devicons").get_icon_color(filename)
					return { { icon, guifg = color }, { " " }, { filename } }
				end,
				hide = {
					only_win = true, -- Hide incline if only one window in tab
				},
			})
		end,
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
