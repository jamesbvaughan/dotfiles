-- A nice file browser
--   https://github.com/stevearc/oil.nvim

vim.pack.add({
  gh('nvim-tree/nvim-web-devicons'),
  gh('stevearc/oil.nvim'),
  gh('refractalize/oil-git-status.nvim'),
})

require("oil").setup({
  keymaps = {
    ["q"] = "actions.close",
  },
  win_options = {
    signcolumn = "yes:2",
  },
})

require("oil-git-status").setup()

vim.keymap.set("n", "-", vim.cmd.Oil)
