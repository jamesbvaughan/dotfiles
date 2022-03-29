local lspconfig = require("lspconfig")
local lsp_status = require("lsp-status")
local lsp_signature = require("lsp_signature")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local null_ls = require("null-ls")

-- vim.lsp.set_log_level('debug')

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	virtual_text = {
		prefix = "●",
	},
	signs = true,
	underline = true,
	update_in_insert = false,
})
lsp_status.register_progress()

local on_attach = function(client, bufnr)
	-- floating function signatures
	lsp_signature.on_attach({
		-- This (bind) is mandatory, otherwise border config won't get registered.
		bind = true,
		handler_opts = {
			border = "single",
		},
	}, bufnr)

	lsp_status.on_attach(client, bufnr)

	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	local function bufmap(combo, mapping)
		local opts = { noremap = true, silent = true }
		vim.api.nvim_buf_set_keymap(bufnr, "n", combo, mapping, opts)
	end

	bufmap("gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
	bufmap("gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
	bufmap("K", "<cmd>lua vim.lsp.buf.hover()<CR>")
	bufmap("gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
	-- bufmap('<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
	bufmap("<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
	bufmap("<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
	bufmap("gr", "<cmd>lua vim.lsp.buf.references()<CR>")
	bufmap("<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
	-- bufmap('<leader>ca', '<cmd>lua vim.lsp.buf.range_code_action()<CR>')
	bufmap("<leader>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>")
	bufmap("[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>")
	bufmap("]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>")
	bufmap("<leader>q", ":TroubleToggle<CR>")
	vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
	vim.cmd([[ command! FormatSync execute 'lua vim.lsp.buf.formatting_seq_sync()' ]])
	bufmap("<leader>f", ":FormatSync<CR>")

	-- Format on save
	-- vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]])
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

-- Set default client capabilities plus window/workDoneProgress for lsp-status
capabilities = vim.tbl_extend("keep", capabilities, lsp_status.capabilities)

-- set the on_attach callback and capabilities for all servers
lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
	capabilities = capabilities,
	on_attach = on_attach,
})

-- Enable the following language servers
lspconfig.bashls.setup({})
lspconfig.cssls.setup({
	settings = {
		scss = {
			lint = {
				unknownAtRules = "ignore",
			},
		},
	},
})
lspconfig.dartls.setup({})
-- lspconfig.denols.setup({})
lspconfig.eslint.setup({})
lspconfig.flow.setup({})
lspconfig.gopls.setup({})
lspconfig.pyright.setup({})
lspconfig.sourcekit.setup({})
lspconfig.tailwindcss.setup({})
lspconfig.terraformls.setup({})
-- lspconfig.flow.setup({})
lspconfig.bashls.setup({})
lspconfig.terraformls.setup({})
lspconfig.dartls.setup({})
lspconfig.tsserver.setup({})
lspconfig.jsonls.setup({
	settings = {
		json = {
			schemas = {
				{
					fileMatch = { "package.json" },
					url = "https://json.schemastore.org/package.json",
				},
				{
					fileMatch = { "tsconfig*.json" },
					url = "https://json.schemastore.org/tsconfig.json",
				},
				{
					fileMatch = { "deno.json", "deno.jsonc" },
					url = "https://deno.land/x/deno/cli/schemas/config-file.v1.json",
				},
				{
					fileMatch = { ".prettierrc", ".prettierrc.json", "prettier.config.json" },
					url = "https://json.schemastore.org/prettierrc.json",
				},
				{
					fileMatch = { ".eslintrc", ".eslintrc.json" },
					url = "https://json.schemastore.org/eslintrc.json",
				},
			},
		},
	},
})

-- Use null-ls for general linters
local null_ls = require("null-ls")
null_ls.setup({
	on_attach = on_attach,
	sources = {
		null_ls.builtins.diagnostics.luacheck,
		null_ls.builtins.diagnostics.markdownlint,
		null_ls.builtins.diagnostics.rubocop,
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.diagnostics.yamllint,
		null_ls.builtins.formatting.autopep8,
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.formatting.rubocop,
		null_ls.builtins.formatting.shfmt,
		null_ls.builtins.formatting.stylua,
	},
})

local signs = {
	Error = " ",
	Warn = " ",
	Hint = " ",
	Info = " ",
}

for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
