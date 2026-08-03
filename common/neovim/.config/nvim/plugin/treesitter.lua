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
		lookahead = true,
		include_surrounding_whitespace = true,
	},
})

-- The main-branch textobjects API no longer registers keymaps from setup(),
-- so bind them manually against the module functions.
local ts_select = require("nvim-treesitter-textobjects.select")
local select_keymaps = {
	["af"] = "@function.outer",
	["if"] = "@function.inner",
	["ac"] = "@class.outer",
	["ic"] = "@class.inner",
	["aa"] = "@parameter.outer",
	["ia"] = "@parameter.inner",
}
for key, query in pairs(select_keymaps) do
	vim.keymap.set({ "x", "o" }, key, function()
		ts_select.select_textobject(query, "textobjects")
	end, { desc = "Select " .. query })
end

local ts_swap = require("nvim-treesitter-textobjects.swap")
vim.keymap.set("n", "<leader>a", function()
	ts_swap.swap_next("@parameter.inner")
end, { desc = "Swap parameter with next" })
vim.keymap.set("n", "<leader>A", function()
	ts_swap.swap_previous("@parameter.inner")
end, { desc = "Swap parameter with previous" })

require("treesitter-context").setup({
	max_lines = 5,
})
