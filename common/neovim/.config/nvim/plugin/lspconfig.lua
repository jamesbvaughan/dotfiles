-- LSP
vim.pack.add({
  gh("b0o/schemastore.nvim"),
  gh("mason-org/mason.nvim"),
  gh("mason-org/mason-lspconfig.nvim"),
  gh("nvim-lua/plenary.nvim"),
  -- gh("pmizio/typescript-tools.nvim"),
  gh("neovim/nvim-lspconfig"),
  { src = gh("mrcjkb/rustaceanvim"), version = vim.version.range("8.x") },
  gh("rachartier/tiny-inline-diagnostic.nvim"),
})

-- Reserve a space in the gutter
vim.opt.signcolumn = "yes"

require("mason").setup()

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

-- knip isn't in nvim-lspconfig, so define it ourselves.
-- https://github.com/webpro-nl/knip/blob/main/packages/language-server/README.md
vim.lsp.config("knip", {
  cmd = { "npx", "@knip/language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "knip.json", "knip.jsonc", "knip.ts", "knip.config.ts", "knip.config.js", "package.json" },
})

-- nvim-lspconfig's oxlint and oxfmt configs look for their binary in
-- `<root_dir>/node_modules/.bin` and nowhere else. That single-level check loses
-- in a Yarn workspaces monorepo: their root_dir is the *nearest* directory with
-- an ox config or an oxlint-mentioning package.json, which in arcol is the
-- individual workspace (every apps/* and packages/* has its own
-- oxlint.config.ts), while Yarn hoists the real binaries up to the repo root.
-- So the lookup misses, both fall back to a bare `oxlint`/`oxfmt` on $PATH, and
-- with neither installed globally the editor reports the servers as unavailable.
--
-- Walking upward fixes it. conform.nvim already does this for the same two
-- binaries via util.from_node_modules, which is why format-on-save kept working
-- while the language servers didn't -- a confusing split worth remembering.
local function node_modules_bin(name, from)
  -- parents() yields `from` itself first when handed a path inside it, so this
  -- checks the root_dir before climbing.
  for dir in vim.fs.parents(vim.fs.joinpath(from, "placeholder")) do
    local bin = vim.fs.joinpath(dir, "node_modules", ".bin", name)
    if vim.fn.executable(bin) == 1 then
      return bin
    end
  end
end

-- Both servers are launched as `{ binary, "--lsp" }`, so one builder covers them.
-- Falling back to the bare name preserves upstream behaviour on a machine where
-- these *are* installed globally.
local function ox_cmd(name)
  return function(dispatchers, config)
    local root = (config or {}).root_dir
    local bin = (root and node_modules_bin(name, root)) or name
    return vim.lsp.rpc.start({ bin, "--lsp" }, dispatchers)
  end
end

-- Overriding only `cmd` keeps upstream's root_dir, filetypes and before_init.
vim.lsp.config("oxlint", { cmd = ox_cmd("oxlint") })
vim.lsp.config("oxfmt", { cmd = ox_cmd("oxfmt") })

vim.lsp.enable("oxfmt")
vim.lsp.enable("oxlint")
vim.lsp.enable("tsc")
vim.lsp.enable("knip")

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

vim.lsp.config("html", {
  settings = {
    html = {},
    css = {},
    javascript = {},
  },
})
vim.lsp.enable("html")

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
      "gri",
      pick("lsp_implementations"),
      vim.tbl_extend("force", opts, { desc = "Go to implementation" })
    )
    vim.keymap.set("n", "gd", pick("lsp_definitions"), vim.tbl_extend("force", opts, { desc = "Go to definition" }))
    vim.keymap.set(
      "n",
      "grt",
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

vim.diagnostic.config({
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
})

-- Better inline diagnostic styling
vim.diagnostic.config({ virtual_text = false })
require("tiny-inline-diagnostic").setup({
  preset = "simple",
})
