-- buffer navigation and management
vim.keymap.set('n', '<s-h>', ':bprev<cr>')
vim.keymap.set('n', '<s-l>', ':bnext<cr>')
vim.keymap.set('n', '<leader>d', ':bdel<cr>')

-- toggle spell checking
vim.keymap.set('n', '<leader>s', ':setlocal spell! spelllang=en_us<cr>')

-- unhighlight the current search
vim.keymap.set('n', 'g/', ':nohlsearch<cr>')

-- move lines up and down in visual mode
vim.keymap.set('x', 'J', ':move \'>+1<cr>gv-gv')
vim.keymap.set('x', 'K', ':move \'<-2<cr>gv-gv')

-- keep the cursor centered when scrolling with C-d and C-u
vim.keymap.set('n', '<c-d>', '<c-d>zz')
vim.keymap.set('n', '<c-u>', '<c-u>zz')

-- keep the cursor centered when navigating between search results
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- allow pasting without clearing the current paste buffer
vim.keymap.set('x', 'p', '\"_dP')

-- open netrw
vim.keymap.set('n', '<leader>e', vim.cmd.Explore)
