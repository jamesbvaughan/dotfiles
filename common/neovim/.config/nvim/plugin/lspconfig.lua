-- LSP
vim.pack.add({
	gh("b0o/schemastore.nvim"),
	gh("mason-org/mason.nvim"),
	gh("mason-org/mason-lspconfig.nvim"),
	gh("j-hui/fidget.nvim"),
	gh("nvim-lua/plenary.nvim"),
	-- gh("pmizio/typescript-tools.nvim"),
	gh("neovim/nvim-lspconfig"),
	{ src = gh("mrcjkb/rustaceanvim"), version = vim.version.range("8.x") },
	gh("rachartier/tiny-inline-diagnostic.nvim"),
})

-- Reserve a space in the gutter
vim.opt.signcolumn = "yes"

require("mason").setup()

require("fidget").setup({
	notification = {
		window = {
			winblend = 0,
		},
	},
})

-- require("typescript-tools").setup({
-- 	settings = {
-- 		expose_as_code_action = {
-- 			"add_missing_imports",
-- 			"remove_unused_imports",
-- 		},
-- 		jsx_close_tag = {
-- 			enable = true,
-- 			filetypes = { "javascriptreact", "typescriptreact" },
-- 		},
-- 	},
-- })

local lspconfig = require("lspconfig")
local blink = require("blink.cmp")

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				unusedLocalExclude = { "_*" },
			},
		},
	},
})

vim.lsp.enable("oxfmt")
vim.lsp.enable("oxlint")
vim.lsp.enable("tsgo")

vim.lsp.config("jsonls", {
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
})

vim.lsp.config("cssls", {
	settings = {
		css = {
			lint = {
				unknownAtRules = "ignore",
			},
		},
	},
})

vim.lsp.config("yamlls", {
	settings = {
		yaml = {
			schemastore = {
				enable = true,
			},
		},
	},
})

vim.diagnostic.config({
	virtual_lines = false,
})

-- Add blink capabilities to lspconfig
lspconfig.util.default_config.capabilities = blink.get_lsp_capabilities(lspconfig.util.default_config.capabilities)

vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function(event)
		local opts = { buffer = event.buf }

		local function pick(name, pick_opts)
			return function()
				local Snacks = require("snacks")
				Snacks.picker(name, pick_opts)
			end
		end

		vim.keymap.set("n", "grr", pick("lsp_references"), vim.tbl_extend("force", opts, { desc = "Go to references" }))
		vim.keymap.set(
			"n",
			"gi",
			pick("lsp_implementations"),
			vim.tbl_extend("force", opts, { desc = "Go to implementation" })
		)
		vim.keymap.set("n", "gd", pick("lsp_definitions"), vim.tbl_extend("force", opts, { desc = "Go to definition" }))
		vim.keymap.set(
			"n",
			"go",
			pick("lsp_type_definitions"),
			vim.tbl_extend("force", opts, { desc = "Go to type definition" })
		)
	end,
})

require("mason-lspconfig").setup({
	ensure_installed = {
		"bashls",
		"cssls",
		"html",
		"jsonls",
		"pyright",
		"lua_ls",
		"tailwindcss",
		"taplo",
		"terraformls",
		"tflint",
		"ts_ls",
		"yamlls",
	},
	automatic_enable = {
		exclude = { "ts_ls", "eslint", "rust_analyzer" },
	},
})

local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Better inline diagnostic styling
vim.diagnostic.config({ virtual_text = false })
require("tiny-inline-diagnostic").setup({
	preset = "simple",
})
