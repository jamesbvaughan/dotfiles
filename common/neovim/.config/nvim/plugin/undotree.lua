-- Visualize and navigate undo history as a tree

vim.cmd.packadd("nvim.undotree")

local undotree = require("undotree")

vim.keymap.set("n", "U", undotree.open, { desc = "Toggle undotree" })
