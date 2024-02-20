local lsp_zero = require("lsp-zero")
local lspconfig = require("lspconfig")

local function lsp_attach(_client, bufnr)
  local opts = { buffer = bufnr }
  lsp_zero.default_keymaps({
    buffer = bufnr,
    exclude = { 'gd', 'go' },
  })

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

lsp_zero.on_attach(lsp_attach)

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
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
  },
  handlers = {
    lsp_zero.default_setup,
    lua_ls = function()
      -- local lua_opts = lsp_zero.nvim_lua_ls()
      -- lspconfig.lua_ls.setup(lua_opts)
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              unusedLocalExclude = { '_*' },
            },
          },
        },
      })
    end,
    jsonls = function()
      lspconfig.jsonls.setup({
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      })
    end,
    yamlls = function()
      lspconfig.yamlls.setup({
        settings = {
          yaml = {
            schemastore = {
              enable = true,
            },
          },
        },
      })
    end,
    eslint = function()
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
    end,
    -- Set this to noop because we're using typescript-tools instead
    tsserver = lsp_zero.noop,
    --   lspconfig.tsserver.setup({
    --   })
    -- end,
    rust_analyzer = function()
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
    end
  }
})

require("typescript-tools").setup({
  on_attach = lsp_attach,
  capabilities = lsp_zero.get_capabilities(),
  -- settings = {
  --   formatting = {
  --     enable = false,
  --   },
  -- },
  -- capabilities = {
  --   document_formatting = false,
  --   document_range_formatting = false,
  -- },
})


-- TODO: Replace this with rustacean.nvim
-- local rust_tools = require("rust-tools")
--
-- rust_tools.setup({
--   server = {
--     on_attach = lsp_attach,
--     ["rust-analyzer"] = {
--       cargo = { allFeatures = true },
--       checkOnSave = {
--         command = "clippy",
--         allFeatures = true
--       },
--     },
--   },
-- })


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

lsp_zero.set_sign_icons({
  error = '',
  warn = '',
  hint = '',
  info = '⚑'
})


require("completion")
