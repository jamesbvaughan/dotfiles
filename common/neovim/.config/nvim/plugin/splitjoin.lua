vim.pack.add({ gh('bennypowers/splitjoin.nvim') })

vim.keymap.set("n", "gJ", function() require("splitjoin").join() end, { desc = "Join the object under cursor" })
vim.keymap.set("n", "gS", function() require("splitjoin").split() end, { desc = "Split the object under cursor" })
