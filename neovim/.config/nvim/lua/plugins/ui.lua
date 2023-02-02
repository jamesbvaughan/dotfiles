-- Plugins related to the Neovim UI
--
return {
  -- Override the default input and select menu styling
  "stevearc/dressing.nvim",

  -- Show a fancy buffer line
  {
    "akinsho/bufferline.nvim",
    dependencies = "kyazdani42/nvim-web-devicons",
    opts = {
      options = {
        show_buffer_close_icons = false,
        show_close_icon = false,
        always_show_bufferline = false,
        diagnostics = "nvim_lsp",
      },
    },
  },

  -- Give hints for keymaps
  {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup()
    end,
  },

  -- Visualize indentation
  "lukas-reineke/indent-blankline.nvim",

  -- Highlight real colors inside nvim (example: #920565)
  {
    "brenoprata10/nvim-highlight-colors",
    opts = {
      enable_tailwind = true,
    },
  },
}
