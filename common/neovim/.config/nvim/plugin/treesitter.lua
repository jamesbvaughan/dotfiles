vim.pack.add({
	gh("nvim-treesitter/nvim-treesitter-textobjects"),
	gh("windwp/nvim-ts-autotag"),
	gh("RRethy/nvim-treesitter-endwise"),
	gh("nvim-treesitter/nvim-treesitter-context"),
	gh("nvim-treesitter/nvim-treesitter"),
	{ src = gh("bezhermoso/tree-sitter-ghostty"), name = "tree-sitter-ghostty" },
})

local parsers = {
	"bash",
	"c",
	"cpp",
	"css",
	"csv",
	"diff",
	"dockerfile",
	"editorconfig",
	"git_config",
	"git_rebase",
	"gitattributes",
	"gitcommit",
	"gitignore",
	"html",
	"html_tags",
	"ini",
	"javascript",
	"jq",
	"json",
	"json5",
	"jsx",
	"lua",
	"markdown",
	"markdown_inline",
	"passwd",
	"python",
	"regex",
	"requirements",
	"rust",
	"sql",
	"ssh_config",
	"terraform",
	"tmux",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"xml",
	"yaml",
	"zsh",
}

require("nvim-treesitter").install(parsers)

vim.api.nvim_create_autocmd("FileType", {
	-- pattern = { unpack(parsers), "typescriptreact" },
	pattern = parsers,
	callback = function()
		-- syntax highlighting, provided by Neovim
		vim.treesitter.start()
		-- folds, provided by Neovim
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.wo.foldmethod = "expr"
		-- indentation, provided by nvim-treesitter
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

-- Disable entire built-in ftplugin mappings to avoid conflicts.
-- pulled from https://github.com/nvim-treesitter/nvim-treesitter-textobjects?tab=readme-ov-file#using-a-package-manager
vim.g.no_plugin_maps = true

require("nvim-treesitter-textobjects").setup({
	select = {
		enable = true,
		lookahead = true,
		include_surrounding_whitespace = true,
		keymaps = {
			["af"] = "@function.outer",
			["if"] = "@function.inner",
			["ac"] = "@class.outer",
			["ic"] = "@class.inner",
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
})

require("treesitter-context").setup({
	max_lines = 5,
})
