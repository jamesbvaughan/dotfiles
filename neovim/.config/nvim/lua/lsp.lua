-- luacheck: globals vim
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local telescope_builtins = require("telescope.builtin")
local telescope_themes = require("telescope.themes")
local typescript_lsp = require("typescript")

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

local on_attach = function(_client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
  vim.keymap.set("n", "gd", function()
    telescope_builtins.lsp_definitions(telescope_themes.get_cursor())
  end)
  vim.keymap.set("n", "K", vim.lsp.buf.hover)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
  -- bufmap('<C-k>', vim.lsp.buf.signature_help)
  vim.keymap.set("n", "<leader>D", function()
    telescope_builtins.lsp_type_definitions(telescope_themes.get_cursor())
  end)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
  vim.keymap.set("n", "gr", vim.lsp.buf.references)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
  vim.keymap.set("v", "<leader>ca", vim.lsp.buf.range_code_action)
  -- vim.keymap.set("n", "<leader>ca", function ()
  --   telescope_builtins.lsp_code_actions(telescope_themes.get_cursor())
  -- end)
  -- vim.keymap.set("n", "<leader>e", vim.lsp.diagnostic.show_line_diagnostics)
  -- vim.keymap.set("n", "[d", vim.lsp.diagnostic.goto_prev)
  -- vim.keymap.set("n", "]d", vim.lsp.diagnostic.goto_next)
  vim.keymap.set("n", "<leader>q", ":TroubleToggle<CR>")

  -- Formatting
  vim.api.nvim_create_user_command('Format', vim.lsp.buf.formatting, {})
  vim.api.nvim_create_user_command('FormatSync', vim.lsp.buf.formatting_seq_sync, {})
  vim.keymap.set("n", "<leader>fm", vim.lsp.buf.format)

  -- Format on save
  -- vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]])
end

-- nvim-cmp supports additional completion capabilities
local capabilities = cmp_nvim_lsp.default_capabilities()

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
lspconfig.clojure_lsp.setup({})
lspconfig.dartls.setup({})
-- lspconfig.denols.setup({})
lspconfig.eslint.setup({
  settings = {
    codeActionOnSave = {
      enable = true,
    },
  }
})
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
lspconfig.rls.setup({
  settings = {
    rust = {
      unstable_features = true,
      build_on_save = false,
      all_features = true,
    },
  },
})
lspconfig.sourcekit.setup({})
lspconfig.tailwindcss.setup({})
lspconfig.terraformls.setup({})
-- lspconfig.tsserver.setup({})
lspconfig.yamlls.setup({
  settings = {
    yaml = {
      schemastore = {
        enable = true,
      },
    },
  },
})

typescript_lsp.setup({
  server = {
    on_attach = on_attach,
    capabilities = capabilities,
  },
})

-- the lua language server requres some additional setup
-- copied from https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
require 'lspconfig'.sumneko_lua.setup {
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
        globals = { 'vim', 'NONE' },
        unusedLocalExclude = { '_*' }
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
    null_ls.builtins.diagnostics.vale,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.rubocop,
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.formatting.joker,
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
  callback = function()
    local opts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      source = 'always',
      scope = 'cursor',
    }
    vim.diagnostic.open_float(nil, opts)
  end
})
