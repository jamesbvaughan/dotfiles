require("options")
require("keymaps")
require("autocmds")
require("plugins-lazy")

local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")

if not configs.bdne then
	configs.bdne = {
		default_config = {
			cmd = { "bun", "/Users/james/code/bdne/lsp-server.ts", "--stdio" },
			filetypes = { "bdne" },
			root_dir = function()
				return vim.loop.cwd()
			end,
		},
	}
end
lspconfig.bdne.setup({})
vim.filetype.add({
	extension = {
		bdne = "bdne",
		kcl = "kcl",
	},
})

if not configs.kcl_lsp then
	configs.kcl_lsp = {
		default_config = {
			cmd = { "kcl-language-server", "server", "--stdio" },
			filetypes = { "kcl" },
			root_dir = lspconfig.util.root_pattern(".git"),
			single_file_support = true,
		},
		docs = {
			description = [=[
https://github.com/KittyCAD/kcl-lsp
https://kittycad.io

The KittyCAD Language Server Protocol implementation for the KCL language.

To better detect kcl files, the following can be added:


    vim.cmd [[ autocmd BufRead,BufNewFile *.kcl set filetype=kcl ]]

]=],
			default_config = {
				root_dir = [[root_pattern(".git")]],
			},
		},
	}
end

lspconfig.kcl_lsp.setup({})

if vim.g.neovide then
	require("gui")
end
