-- Obsidian vault integration
--   https://github.com/obsidian-nvim/obsidian.nvim

vim.pack.add({
  { src = gh("obsidian-nvim/obsidian.nvim"), version = vim.version.range("*") },
})

---@module 'obsidian'
---@type obsidian.config
require("obsidian").setup({
  legacy_commands = false,

  workspaces = {
    { name = "notes", path = "~/notes" },
  },

  daily_notes = {
    folder = "daily notes",
    date_format = "%Y-%m-%d",
  },

  templates = {
    folder = "templates",
  },

  attachments = {
    folder = "attachments",
  },

  picker = {
    name = "snacks.picker",
  },
})

vim.keymap.set("n", "<leader>oo", "<cmd>Obsidian quick_switch<cr>", { desc = "Obsidian: quick switch" })
vim.keymap.set("n", "<leader>os", "<cmd>Obsidian search<cr>", { desc = "Obsidian: search" })
vim.keymap.set("n", "<leader>on", "<cmd>Obsidian new<cr>", { desc = "Obsidian: new note" })
vim.keymap.set("n", "<leader>ot", "<cmd>Obsidian today<cr>", { desc = "Obsidian: today" })
vim.keymap.set("n", "<leader>oy", "<cmd>Obsidian yesterday<cr>", { desc = "Obsidian: yesterday" })
vim.keymap.set("n", "<leader>od", "<cmd>Obsidian dailies<cr>", { desc = "Obsidian: dailies" })
vim.keymap.set("n", "<leader>ob", "<cmd>Obsidian backlinks<cr>", { desc = "Obsidian: backlinks" })
vim.keymap.set("n", "<leader>og", "<cmd>Obsidian tags<cr>", { desc = "Obsidian: tags" })
vim.keymap.set("n", "<leader>op", "<cmd>Obsidian paste_img<cr>", { desc = "Obsidian: paste image" })
