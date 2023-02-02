return {
  {
    "folke/trouble.nvim",
    dependencies = {
      "kyazdani42/nvim-web-devicons",
    },
    keys = {
      { "<leader>q", ":TroubleToggle<cr>" },
    },
    opts = {
      auto_close = true,
      auto_open = true,
      height = 5,
      mode = "document_diagnostics",
      group = false,
      padding = false,
      indent_lines = false,
    },
  },
}
