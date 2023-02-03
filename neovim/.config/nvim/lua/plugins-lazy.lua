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

  -- Better integration between nvim and tmux
  -- "christoomey/vim-tmux-navigator",

  "windwp/nvim-autopairs",

  {
    "mbbill/undotree",
    keys = {
      { "U", vim.cmd.UndotreeToggle },
    },
  },

  -- quick navigation within a file
  {
    'ggandor/leap.nvim',
    config = function()
      require('leap').set_default_keymaps()

      -- Grey out the search area
      vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
    end,
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
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})


require("lsp")