local lsp = require("lsp-zero").preset({})
local lspconfig = require("lspconfig")
local ih = require("lsp-inlayhints")

ih.setup()


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
  -- "glslls",
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

-- Tell lsp-zero to skip rust-analyzer because we use rust-tools for rust LSP
-- config.
-- lsp.skip_server_setup({ "rust_analyzer" })


-- Config for specific language servers
--
lspconfig.jsonls.setup({
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
})
lspconfig.yamlls.setup({
  settings = {
    yaml = {
      schemastore = {
        enable = true,
      },
    },
  },
})
lspconfig.lua_ls.setup(lsp.nvim_lua_ls())
-- lspconfig.lua_ls.setup({
--   settings = {
--     Lua = {
--       diagnostics = {
--         globals = { 'vim' },
--         unusedLocalExclude = { '_*' },
--       },
--     },
--   },
-- })
-- lspconfig.cssls.setup({
--   settings = {
--     scss = {
--       lint = {
--         unknownAtRules = "ignore",
--       },
--     },
--   },
-- })
lspconfig.eslint.setup({
  capabilities = {
    document_formatting = false,
    document_range_formatting = false,
  },
  settings = {
    codeActionOnSave = {
      enable = true,
    },
    -- Disable some rules to speed up lint results.
    -- These still run in pre-commit hooks and in CI.
    rulesCustomizations = {
      { rule = "@typescript-eslint/no-misused-promises",  severity = "off" },
      { rule = "@typescript-eslint/no-unsafe-argument",   severity = "off" },
      { rule = "@typescript-eslint/no-unsafe-assignment", severity = "off" },
      { rule = "import/defaults",                         severity = "off" },
      { rule = "import/namespace",                        severity = "off" },
      { rule = "import/no-cycle",                         severity = "off" },
      { rule = "import/no-unresolved",                    severity = "off" },
    }
  }
})
lspconfig.tsserver.setup({
  -- settings = {
  --   formatting = {
  --     enable = false,
  --   },
  -- },
  capabilities = {
    document_formatting = false,
    document_range_formatting = false,
  },
  on_attach = function(client, bufnr)
    ih.on_attach(client, bufnr)
  end,
  -- I've commented this out because I don't think I actually like inlay hints
  -- settings = {
  --   typescript = {
  --     inlayHints = {
  --       includeInlayParameterNameHints = 'all',
  --       includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  --       includeInlayFunctionParameterTypeHints = true,
  --       includeInlayVariableTypeHints = true,
  --       includeInlayVariableTypeHintsWhenTypeMatchesName = false,
  --       includeInlayPropertyDeclarationTypeHints = true,
  --       includeInlayFunctionLikeReturnTypeHints = true,
  --       includeInlayEnumMemberValueHints = true,
  --     }
  --   },
  --   javascript = {
  --     inlayHints = {
  --       includeInlayParameterNameHints = 'all',
  --       includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  --       includeInlayFunctionParameterTypeHints = true,
  --       includeInlayVariableTypeHints = true,
  --       includeInlayVariableTypeHintsWhenTypeMatchesName = false,
  --       includeInlayPropertyDeclarationTypeHints = true,
  --       includeInlayFunctionLikeReturnTypeHints = true,
  --       includeInlayEnumMemberValueHints = true,
  --     }
  --   }
  -- }
})
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
lspconfig.rust_analyzer.setup({
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      checkOnSave = {
        command = "clippy",
        allFeatures = true
      },
    },
  },
})


-- Override some default keymaps
lsp.set_preferences({
  set_lsp_keymaps = { omit = { 'gd', 'go' } }
})

local function lsp_attach(_, bufnr)
  local opts = { buffer = bufnr }

  -- if client.name == "tsserver" then
  --   client.capabilities.document_formatting = false
  --   client.capabilities.document_range_formatting = false
  -- end

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
end

lsp.on_attach(lsp_attach)

-- lsp.format_on_save({
--   servers = {
--     ['lua_ls'] = {'lua'},
--     ['rust_analyzer'] = {'rust'},
--   }
-- })
-- lsp.format_on_save({
--   format_opts = {
--     timeout_ms = 10000,
--   },
--   servers = {
--     ['null-ls'] = {'javascript', 'typescript'},
--   }
-- })


local rust_tools = require("rust-tools")

rust_tools.setup({
  server = {
    on_attach = lsp_attach,
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      checkOnSave = {
        command = "clippy",
        allFeatures = true
      },
    },
  },
})


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

lsp.set_sign_icons({
  error = '',
  warn = '',
  hint = '',
  info = '⚑'
})


require("null_ls")
require("completion")


lsp.setup()
