return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			-- Additional text objects
			"nvim-treesitter/nvim-treesitter-textobjects",
			-- auto-complete html tags
			"windwp/nvim-ts-autotag",
			-- auto-add "end" in ruby and similar languages
			"RRethy/nvim-treesitter-endwise",
			-- Show context at the top of the butter
			"nvim-treesitter/nvim-treesitter-context",
		},
		build = function()
			vim.cmd.TSUpdate()
		end,
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				ensure_installed = "all",
				auto_install = true,
				highlight = {
					enable = true,
				},
				indent = {
					enable = true,
				},
				autotag = {
					enable = true,
				},
				endwise = {
					enable = true,
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						include_surrounding_whitespace = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							-- "a" for "argument" since "p" could clash with the default of
							-- "paragraph"
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
						},
					},
					lsp_interop = {
						enable = true,
						border = "none",
						floating_preview_opts = {},
						peek_definition_code = {
							["<leader>df"] = "@function.outer",
							["<leader>dF"] = "@class.outer",
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>a"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>A"] = "@parameter.inner",
						},
					},
				},
			})

			require("treesitter-context").setup({
				max_lines = 5,
			})
		end,
	},
}
