-- luacheck: globals vim
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- vim.lsp.set_log_level('debug')

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	virtual_text = false,
  float = {
    source = "always",
  },
	signs = true,
	underline = true,
	update_in_insert = false,
})

local on_attach = function(client, bufnr)
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
	bufmap('<leader>ca', '<cmd>lua vim.lsp.buf.range_code_action()<CR>')
	bufmap("<leader>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>")
	bufmap("[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>")
	bufmap("]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>")
	bufmap("<leader>q", ":TroubleToggle<CR>")

  -- Formatting
	vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
	vim.cmd([[ command! FormatSync execute 'lua vim.lsp.buf.formatting_seq_sync()' ]])
	bufmap("<leader>f", ":FormatSync<CR>")

	-- Format on save
	-- vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]])
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

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
lspconfig.graphql.setup({})
lspconfig.html.setup({})
lspconfig.jsonls.setup({
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
    },
  },
})
lspconfig.prismals.setup({})
lspconfig.pylsp.setup({})
lspconfig.pyright.setup({})
lspconfig.sourcekit.setup({})
lspconfig.tailwindcss.setup({})
lspconfig.terraformls.setup({})
lspconfig.tsserver.setup({})
lspconfig.yamlls.setup({})

-- the lua language server requres some additional setup
-- copied from https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
require'lspconfig'.sumneko_lua.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
    },
  },
}

-- Use null-ls for general linters
local null_ls = require("null-ls")
null_ls.setup({
	on_attach = on_attach,
	sources = {
		null_ls.builtins.diagnostics.rubocop,
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.formatting.rubocop,
		null_ls.builtins.formatting.shfmt,
	},
})

-- Configure symbols for diagnostic signs
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

-- Show line diagnostics in hover window
vim.o.updatetime = 500
vim.api.nvim_create_autocmd("CursorHold", {
  buffer = bufnr,
  callback = function()
    local opts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = 'rounded',
      source = 'always',
      prefix = ' ',
      scope = 'cursor',
    }
    vim.diagnostic.open_float(nil, opts)
  end
})
