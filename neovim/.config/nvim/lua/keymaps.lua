-- buffer navigation
vim.keymap.set('n', '<s-h>', vim.cmd.bprev)
vim.keymap.set('n', '<s-l>', vim.cmd.bnext)

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

vim.keymap.set(
  'n',
  '<leader>d',
  vim.cmd.bdelete,
  { desc = "Close the current buffer" }
)

vim.keymap.set(
  'n',
  '<leader>s',
  function()
    vim.opt_local.spell = not vim.opt_local.spell:get()
  end,
  { desc = "Toggle spell checking" }
)

vim.keymap.set(
  'n',
  'g/',
  vim.cmd.nohlsearch,
  { desc = "Clear the search highlight" }
)

vim.keymap.set(
  'n',
  '<leader>e',
  vim.cmd.Explore,
  { desc = "Open the explorer" }
)
