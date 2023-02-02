--- use space as the leader key
vim.g.mapleader = ' '

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
-- vim.opt.relativenumber = true

---- auto read files changed outside vim
vim.opt.autoread = true

---- enable the mouse
vim.opt.mouse = 'a'

---- use the system clipboard
vim.opt.clipboard = 'unnamedplus'

---- start scrolling before hitting the bottom
vim.opt.scrolloff = 5

---- stabilize the quickfix window's effect on other windows
vim.opt.splitkeep = 'screen'

---- ignore these when autocompleting paths
vim.opt.wildignore = vim.opt.wildignore + 'node_modules/*,vendor/bundle/*,tmp/*'

---- only use case sensitive search when uppercase
vim.opt.ignorecase = true
vim.opt.smartcase = true

---- persistent undo files
vim.opt.undodir = vim.fn.getenv('HOME') .. '/.local/nvim/undofiles'
vim.opt.undofile = true

---- always show the sign column
vim.opt.signcolumn = 'yes'

---- always show the sign column
vim.opt.colorcolumn = '80'

--- enable 24-bit color
vim.opt.termguicolors = true

---- configure the spell file
vim.opt.spellfile = vim.fn.getenv('HOME') .. '/.config/nvim/spell/en.utf-8.add'

---- don't keep search results highlighted
vim.opt.hlsearch = false

---- highlight search results incrementally
vim.opt.incsearch = true

---- hide the netrw banner
vim.g.netrw_banner = 0

vim.opt.laststatus = 3
