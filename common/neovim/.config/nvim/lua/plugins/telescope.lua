local telescope_builtin = function(name, opts)
  return function()
    require("telescope.builtin")[name](opts)
  end
end

return {
  {
    "nvim-telescope/telescope.nvim",
    priority = 500,
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    keys = {
      {
        "<leader>ff",
        telescope_builtin("find_files"),
        desc = "Find files"
      },
      {
        "<leader>fg",
        telescope_builtin("live_grep"),
        desc = "Live grep"
      },
      {
        "<leader>fb",
        telescope_builtin("buffers"),
        desc = "Search open buffers"
      },
      {
        "<leader>fa",
        telescope_builtin("git_files", { show_untracked = true }),
        desc = "Find files in current git repo",
      },
      {
        "<leader>fs",
        telescope_builtin("grep_string"),
        desc = "Search for the word under the cursor",
      },
      {
        "<leader>ft",
        telescope_builtin("treesitter"),
        desc = "Search treesitter symbols",
      },
      {
        "<leader>fc",
        telescope_builtin("git_files", {
          cwd = "~/.dotfiles",
          show_untracked = true,
        }),
        desc = "Search dotfiles repo",
      },
    },
    config = function()
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
