-- Bootstrap lazy.nvim
--
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


-- Install plugins
--
require("lazy").setup({
  { import = "plugins" },

  "tpope/vim-surround",

  "tpope/vim-repeat",

  {
    "knubie/vim-kitty-navigator",
    build = "cp ./*.py ~/.config/kitty/"
  },

  "windwp/nvim-autopairs",

  -- buffer line
  {
    "akinsho/bufferline.nvim",
    dependencies = "kyazdani42/nvim-web-devicons",
    opts = {
      options = {
        show_buffer_close_icons = false,
        show_close_icon = false,
        always_show_bufferline = false,
        diagnostics = true,
      },
    },
  },

  {
    "mbbill/undotree",
    keys = {
      { "U", ":UndotreeToggle<cr>" }
    },
  },

  "folke/which-key.nvim",

  -- visualize indentation
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      show_current_context = true,
    },
  },

  -- quick navigation within a file
  {
    'ggandor/leap.nvim',
    config = function()
      require('leap').set_default_keymaps()
    end,
  },

  -- highlight real colors inside nvim
  -- for example: "#920565"
  {
    "brenoprata10/nvim-highlight-colors",
    opts = {
      enable_tailwind = true,
    },
  },

  -- nice bindings for working with comments
  {
    'numToStr/Comment.nvim',
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function()
      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })
    end,
  },
}, {
  checker = {
    enabled = true,
  },
})

require("lsp")
require("completion")
