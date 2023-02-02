return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    keys = {
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files()
        end
      },
      {
        "<leader>fg",
        function()
          require("telescope.builtin").live_grep()
        end
      },
      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers()
        end
      },
      {
        "<leader>fa",
        function()
          require("telescope.builtin").git_files({ show_untracked = true })
        end
      },
      {
        "<leader>fs",
        function()
          require("telescope.builtin").grep_string()
        end
      },
      {
        "<leader>ft",
        function()
          require("telescope.builtin").treesitter()
        end
      },
      {
        "<leader>fc",
        function()
          require("telescope.builtin").git_files({
            cwd = "~/.dotfiles",
            show_untracked = true,
          })
        end
      },
    },
    config = function ()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = actions.close
            },
          },
        }
      })

      telescope.load_extension("fzf")
    end
  },
}
