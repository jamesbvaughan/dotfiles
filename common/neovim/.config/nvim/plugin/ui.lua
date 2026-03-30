-- Plugins related to the Neovim UI

vim.pack.add({
	gh("akinsho/bufferline.nvim"),
	gh("folke/which-key.nvim"),
	gh("folke/todo-comments.nvim"),
	gh("brenoprata10/nvim-highlight-colors"),
	gh("b0o/incline.nvim"),
	gh("RRethy/vim-illuminate"),
})

-- Bufferline
require("bufferline").setup({
	options = {
		show_buffer_close_icons = false,
		show_close_icon = false,
		always_show_bufferline = false,
		diagnostics = "nvim_lsp",
	},
})

-- Which-key
vim.o.timeout = true
vim.o.timeoutlen = 300
require("which-key").setup()

-- Todo comments
require("todo-comments").setup()

-- Highlight colors
require("nvim-highlight-colors").setup({
	enable_tailwind = true,
})

-- Incline (floating filename label)
require("incline").setup({
	window = { margin = { vertical = 0, horizontal = 1 } },
	render = function(props)
		local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
		local icon, color = require("nvim-web-devicons").get_icon_color(filename)
		return { { icon, guifg = color }, { " " }, { filename } }
	end,
	hide = {
		only_win = true,
	},
})

-- Illuminate (highlight symbol under cursor)
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
