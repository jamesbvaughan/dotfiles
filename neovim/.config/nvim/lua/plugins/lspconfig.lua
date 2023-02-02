return {
  {
    "williamboman/mason.nvim",
    setup = function()
      require("mason").setup()
    end
  },
  { "williamboman/mason-lspconfig.nvim", lazy = false },

  -- Collection of configurations for built-in LSP client
  "neovim/nvim-lspconfig",

  -- Pull JSON schemas from SchemsStore for use with jsonls
  "b0o/schemastore.nvim",

  -- LSP plugin for non-LSP sources, like linters
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
  },

  -- LSP plugin for typescript
  "jose-elias-alvarez/typescript.nvim",
}
