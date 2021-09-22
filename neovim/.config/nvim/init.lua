require('utils')


-- Options

---- don't use swap files
vim.opt.swapfile = false

---- indentation (2 spaces, no tabs)
local indent = 2
vim.opt.tabstop = indent
vim.opt.softtabstop = indent
vim.opt.shiftwidth = indent
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

---- show line numbers
vim.opt.number = true

---- allow background buffers
vim.opt.hidden = true

---- auto read files changed outside vim
vim.opt.autoread = true

---- enable the mouse
vim.opt.mouse = 'a'

---- use the system clipboard
vim.opt.clipboard = 'unnamedplus'

---- start scrolling before hitting the bottom
vim.opt.scrolloff = 5

---- ignore these when autocompleting paths
vim.opt.wildignore = vim.opt.wildignore + 'node_modules/*,vendor/bundle/*,tmp/*'


-- General Keybindings

---- split navigation
map('n', '<c-h>', ':wincmd h<cr>')
map('n', '<c-j>', ':wincmd j<cr>')
map('n', '<c-k>', ':wincmd k<cr>')
map('n', '<c-l>', ':wincmd l<cr>')

---- buffer navigation and management
map('n', '<s-h>', ':bprev<cr>')
map('n', '<s-l>', ':bnext<cr>')
map('n', '<leader>d', ':bdel<cr>')

---- open up this file
map('n', '<leader>v', ':e ~/.config/nvim/init.lua<cr>')

---- toggle spell checking
map('n', '<leader>s', ':setlocal spell! spelllang=en_us<cr>')

---- unhighlight the current search
map('n', 'g/', ':nohlsearch<cr>')


-- Plugins

require('plugins')


-- Plugin Keybindings

---- telescope keybindings
map('n', 'ff', ':Telescope find_files<cr>')
map('n', 'fg', ':Telescope live_grep<cr>')
map('n', 'fb', ':Telescope buffers<cr>')
map('n', 'fa', ':Telescope git_files<cr>')

---- rhubarb bindings
map('', 'gh', ':GBrowse<cr>')

---- fugitive keybindings
map('n', 'gb', ':GBrowse<cr>')


-- Theme

vim.opt.termguicolors = true
vim.cmd('colorscheme dracula')


-- Load any extra machine-specific config
require('extra')
