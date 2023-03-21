local lsp = require("lsp-zero")


lsp.preset("recommended")


-- Configure lua language server for Neovim
--
lsp.nvim_workspace({
  library = vim.api.nvim_get_runtime_file('', true)
})

lsp.ensure_installed({
  "bashls",
  "cssls",
  "eslint",
  -- "gopls",
  "graphql",
  "html",
  "jsonls",
  "openscad_lsp",
  "prismals",
  "pyright",
  "rust_analyzer",
  "lua_ls",
  "tailwindcss",
  "terraformls",
  "tsserver",
  "yamlls",
})


-- Config for specific language servers
--
lsp.configure('jsonls', {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
})
lsp.configure('yamlls', {
  settings = {
    yaml = {
      schemastore = {
        enable = true,
      },
    },
  },
})
lsp.configure('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
        unusedLocalExclude = { '_*' },
      },
    },
  },
})
-- lspconfig.cssls.setup({
--   settings = {
--     scss = {
--       lint = {
--         unknownAtRules = "ignore",
--       },
--     },
--   },
-- })
-- lspconfig.eslint.setup({
--   settings = {
--     codeActionOnSave = {
--       enable = true,
--     },
--   }
-- })
-- lspconfig.openscad_lsp.setup({
--   cmd = { "/Users/james/code/openscad-LSP/target/debug/openscad-lsp", "--stdio" },
--   settings = {
--     openscad = {
--       -- fmt_exe = "/opt/homebrew/bin/clang-format",
--       fmt_style = "gnu",
--     },
--   },
-- })

-- require("typescript").setup({
--   server = {
--     on_attach = on_attach,
--     capabilities = capabilities,
--   },
-- })


-- Override some default keymaps
lsp.set_preferences({
  set_lsp_keymaps = { omit = { 'gd', 'go' } }
})
lsp.on_attach(function(_client, bufnr)
  local opts = { buffer = bufnr }

  vim.keymap.set("n", "<leader>fm", vim.cmd.LspZeroFormat,
    vim.tbl_extend("force", opts, { desc = "Format" }))

  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,
    vim.tbl_extend("force", opts, { desc = "Show available code actions" }))

  vim.keymap.set("n", "gd", function()
    require("telescope.builtin").lsp_definitions(
      require("telescope.themes").get_cursor()
    )
  end, vim.tbl_extend("force", opts, { desc = "Go to definition" }))

  vim.keymap.set("n", "go", function()
    require("telescope.builtin").lsp_type_definitions(
      require("telescope.themes").get_cursor()
    )
  end, vim.tbl_extend("force", opts, { desc = "Go to type definition" }))
end)


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


require("null_ls")
require("completion")


lsp.setup()
