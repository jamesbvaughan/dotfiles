-- luacheck: globals vim


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
vim.opt.relativenumber = true

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

---- only use case sensitive search when uppercase
vim.opt.ignorecase = true
vim.opt.smartcase = true

---- persistent undo files
vim.opt.undodir = vim.fn.getenv('HOME')..'/.local/nvim/undofiles'
vim.opt.undofile = true


---- configure the spell file
vim.opt.spellfile = vim.fn.getenv('HOME')..'/.config/nvim/spell/en.utf-8.add'


-- Keybindings

--- use space as the leader key
vim.g.mapleader = ' '

---- split navigation
vim.keymap.set('n', '<c-h>', ':wincmd h<cr>')
vim.keymap.set('n', '<c-j>', ':wincmd j<cr>')
vim.keymap.set('n', '<c-k>', ':wincmd k<cr>')
vim.keymap.set('n', '<c-l>', ':wincmd l<cr>')

---- buffer navigation and management
vim.keymap.set('n', '<s-h>', ':bprev<cr>')
vim.keymap.set('n', '<s-l>', ':bnext<cr>')
vim.keymap.set('n', '<leader>d', ':bdel<cr>')

---- toggle spell checking
vim.keymap.set('n', '<leader>s', ':setlocal spell! spelllang=en_us<cr>')

---- unhighlight the current search
vim.keymap.set('n', 'g/', ':nohlsearch<cr>')


-- Filetype matching

--- This enables the currently opt-in new and faster filetype master
--- You can remove this after it's made default
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0


-- Turn on spell checking in git commits
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  command = "setlocal spell",
})


-- Plugins

require('plugins')

vim.cmd("colorscheme gruvbox")


-- Load any extra machine-specific config
pcall(require, 'extra')
