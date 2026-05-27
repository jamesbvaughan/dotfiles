-- Better integration between nvim and tmux
--   https://github.com/christoomey/vim-tmux-navigator

vim.pack.add({ gh("christoomey/vim-tmux-navigator") })

vim.keymap.set("n", "<c-h>", "<C-U>TmuxNavigateLeft<cr>")
vim.keymap.set("n", "<c-j>", "<C-U>TmuxNavigateDown<cr>")
vim.keymap.set("n", "<c-k>", "<C-U>TmuxNavigateUp<cr>")
vim.keymap.set("n", "<c-l>", "<C-U>TmuxNavigateRight<cr>")
vim.keymap.set("n", "<c-\\>", "<C-U>TmuxNavigatePrevious<cr>")
