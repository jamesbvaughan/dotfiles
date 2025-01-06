-- MDX highlighting
--   https://github.com/davidmh/mdx.nvim

return {
	"davidmh/mdx.nvim",
	config = true,
	event = "BufEnter *.mdx",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
}
