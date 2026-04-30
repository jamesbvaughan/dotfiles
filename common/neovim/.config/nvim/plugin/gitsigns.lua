-- Show various git indicators
--   https://github.com/lewis6991/gitsigns.nvim

vim.pack.add({ gh("lewis6991/gitsigns.nvim") })

---@type Gitsigns.Config
---@diagnostic disable-next-line: missing-fields
require("gitsigns").setup({
	current_line_blame = true,
	current_line_blame_opts = {
		ignore_whitespace = true,
		delay = 500,
	},
})
