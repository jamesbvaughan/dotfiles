return {
  -- Pull JSON schemas from SchemsStore for use with jsonls
  "b0o/schemastore.nvim",

  -- LSP plugin for non-LSP sources, like linters
  "jose-elias-alvarez/null-ls.nvim",

  "jay-babu/mason-null-ls.nvim",

  -- LSP plugin for typescript
  "jose-elias-alvarez/typescript.nvim",

  -- github copilot
  {
    "zbirenbaum/copilot.lua",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end
  },

  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup({
        formatters = {
          insert_text = require("copilot_cmp.format").remove_existing
        },
      })
    end
  },

  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { "hrsh7th/cmp-cmdline" },
      { "hrsh7th/cmp-nvim-lsp-signature-help" },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lua' },
      { 'hrsh7th/cmp-path' },
      { "onsails/lspkind-nvim" },
      { "petertriho/cmp-git" },
      { 'saadparwaiz1/cmp_luasnip' },

      -- Snippets
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },
    }
  }
}
