return {
  {
    "tpope/vim-fugitive",
    dependencies = "tpope/vim-rhubarb",
    lazy = false,
    keys = {
      { "gh", vim.cmd.GBrowse, desc = "Open the current file in GitHub" },
      { "gl", ":Git log --pretty --oneline --abbrev-commit --graph -20 <cr>" },
    }
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        ignore_whitespace = true,
        delay = 500,
      },
    },
  },

  {
    'TimUntersberger/neogit',
    dependencies = 'nvim-lua/plenary.nvim',
    keys = {
      { "<leader>g", vim.cmd.Neogit, desc = "Open neogit" },
    },
    opts = {
      disable_insert_on_commit = false,
      integrations = {
        diffview = true
      }
    }
  },

  {
    'sindrets/diffview.nvim',
    keys = {
      {
        "<leader>h",
        function() vim.cmd.DiffviewFileHistory("%") end,
        desc = "Open diffview for the current file"
      },
    },
    opts = {
      enhanced_diff_hl = true,
    },
  },
}
