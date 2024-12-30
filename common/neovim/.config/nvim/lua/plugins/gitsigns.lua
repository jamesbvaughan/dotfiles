-- Show various git indicators
--   https://github.com/lewis6991/gitsigns.nvim

return {
	"lewis6991/gitsigns.nvim",
	event = "VeryLazy",

	---@type Gitsigns.Config
	---@diagnostic disable-next-line: missing-fields
	opts = {
		current_line_blame = true,
		current_line_blame_opts = {
			ignore_whitespace = true,
			delay = 500,
		},
	},
}
