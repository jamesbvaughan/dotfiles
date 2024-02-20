return {
  {
    "jay-babu/mason-null-ls.nvim",
    -- event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      local lsp = require("lsp-zero")
      local null_ls = require('null-ls')

      local null_opts = lsp.build_options('null-ls', {})

      null_ls.setup({
        on_attach = null_opts.on_attach,
        sources = {
          -- null_ls.builtins.diagnostics.glslc,
          -- null_ls.builtins.diagnostics.glslc.with({
          --   extra_args = { "--target-env=opengl" },
          -- }),
          -- null_ls.builtins.diagnostics.rubocop,
          null_ls.builtins.diagnostics.shellcheck,
          -- null_ls.builtins.diagnostics.vale,
          null_ls.builtins.formatting.autopep8,
          null_ls.builtins.formatting.prettierd,
          -- null_ls.builtins.formatting.rubocop,
          null_ls.builtins.formatting.shfmt,
          null_ls.builtins.formatting.joker,
        }
      })

      require("mason-null-ls").setup({
        ensure_installed = nil,
        automatic_installation = true,
        automatic_setup = false,
      })
    end
  }
}
