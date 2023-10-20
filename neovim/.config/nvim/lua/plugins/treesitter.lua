return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      -- Additional text objects
      "nvim-treesitter/nvim-treesitter-textobjects",
      -- auto-complete html tags
      "windwp/nvim-ts-autotag",
      -- auto-add "end" in ruby and similar languages
      "RRethy/nvim-treesitter-endwise",
      -- Handle mutliple languages per file for picking comment strings
      'JoosepAlviste/nvim-ts-context-commentstring',
      -- Show context at the top of the butter
      "nvim-treesitter/nvim-treesitter-context"
    },
    build = function()
      vim.cmd.TSUpdate()
    end,
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "css",
          "go",
          "graphql",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "prisma",
          "python",
          "ruby",
          "rust",
          "scss",
          "tsx",
          "typescript",
          "vim",
          "yaml",
        },
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
        autotag = {
          enable = true,
        },
        endwise = {
          enable = true,
        },
        context_commentstring = {
          enable = true,
          enable_autocmd = false,
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            include_surrounding_whitespace = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              -- Commenting these out so they don't conflict with "paragraph"
              -- ["ap"] = "@parameter.outer",
              -- ["ip"] = "@parameter.inner",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
        },
      })

      vim.opt.foldlevel = 20
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
    end,
  },
}
