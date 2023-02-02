return {
  {
    "tpope/vim-fugitive",
    dependencies = "tpope/vim-rhubarb",
    keys = {
      { "gh", ":GBrowse<cr>" },
      -- { "gs", ":Git<cr>" },
      -- { "gl", ":Git log --pretty --oneline --abbrev-commit --graph -20 <cr>" },
    }
  },

  -- git signs
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
      {
        "<leader>g",
        function()
          -- Open the neogit status buffer for the current buffer's repository
          -- require("neogit").open({ cwd = vim.fn.expand("%:p:h") })
          --local cwd = vim.fn.expand('%:p:h')
          require("neogit").open()
          --vim.cmd(":lcd" .. cwd)
        end
      },
    },
    opts = {
      integrations = {
        diffview = true
      }
    }
  },

  'sindrets/diffview.nvim',
}
