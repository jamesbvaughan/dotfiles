-- Visualize and navigate undo history as a tree
--   https://github.com/mbbill/undotree

vim.pack.add({ gh("mbbill/undotree") })

vim.keymap.set("n", "U", vim.cmd.UndotreeToggle)
