-- Visualize and navigate undo history as a tree

vim.cmd.packadd("nvim.undotree")

vim.keymap.set("n", "U", ":Undotree<CR>", { desc = "Toggle undotree" })
