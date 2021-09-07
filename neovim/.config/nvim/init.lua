require('utils')


-- Options

-- don't use swap files
vim.opt.swapfile = false

-- use 2 spaces rather than tabs
local indent = 2
vim.opt.tabstop = indent
vim.opt.shiftwidth = indent
vim.opt.softtabstop = indent
vim.opt.expandtab = true

-- show line numbers
vim.opt.number = true

-- allow background buffers
vim.opt.hidden = true

-- automatically indent code
vim.opt.autoindent = true

-- auto read files changed outside vim
vim.opt.autoread = true

-- enable the mouse
vim.opt.mouse = 'a'

-- use the system clipboard
vim.opt.clipboard = 'unnamedplus'


-- Keybindings

-- split navigation
map('n', '<c-h>', ':wincmd h<cr>')
map('n', '<c-j>', ':wincmd j<cr>')
map('n', '<c-k>', ':wincmd k<cr>')
map('n', '<c-l>', ':wincmd l<cr>')

-- buffer navigation
map('n', '<s-h>', ':bprev<cr>')
map('n', '<s-l>', ':bnext<cr>')

-- open up this file
map('n', '<leader>v', ':e ~/.config/nvim/init.lua<cr>')

-- toggle spell checking
map('n', '<leader>s', ':setlocal spell! spelllang=en_us<cr>')

-- telescope Keybindings
map('n', 'ff', ':Telescope find_files<cr>')
map('n', 'fg', ':Telescope live_grep<cr>')
map('n', 'fb', ':Telescope buffers<cr>')
map('n', 'fa', ':Telescope git_files<cr>')


-- Plugins

require('plugins')


-- Theme

-- I don't fully understand why this is necessary,
-- but this theme won't work without it.
vim.opt.termguicolors = true
vim.cmd('colorscheme dracula')
