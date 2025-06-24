--- use space as the leader key
vim.g.mapleader = " "

---- don't use swap files
vim.opt.swapfile = false

---- disable the startup screen
vim.opt.shortmess:append({ I = true })

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

---- highlight the current line
vim.opt.cursorline = true

---- use the system clipboard
vim.opt.clipboard = "unnamedplus"

---- start scrolling before hitting the bottom
vim.opt.scrolloff = 5

---- stabilize the quickfix window's effect on other windows
vim.opt.splitkeep = "screen"

---- ignore these when autocompleting paths
vim.opt.wildignore = vim.opt.wildignore + "node_modules/*,vendor/bundle/*,tmp/*"

---- only use case sensitive search when uppercase
vim.opt.ignorecase = true
vim.opt.smartcase = true

---- persistent undo files
vim.opt.undodir = vim.fn.getenv("HOME") .. "/.local/nvim/undofiles"
vim.opt.undofile = true

---- always show the sign column
vim.opt.signcolumn = "yes"

---- set a default text width and show a column there
vim.opt.textwidth = 80
vim.opt.colorcolumn = "+1"

--- enable 24-bit color
vim.opt.termguicolors = true

--- enable spell checking
vim.opt.spell = true

---- configure the spell file
vim.opt.spellfile = vim.fn.getenv("HOME") .. "/.config/nvim/spell/en.utf-8.add"

---- don't keep search results highlighted
-- vim.opt.hlsearch = false

---- highlight search results incrementally
vim.opt.incsearch = true

---- folding
vim.o.fillchars = "eob: ,fold: ,foldopen:,foldsep: ,foldclose:"
vim.o.foldcolumn = "1"
vim.o.foldenable = true
-- vim.o.foldexpr = "v:lua.vim.lsp.foldexpr()"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldmethod = "expr"

---- use a single status line for all windows
vim.opt.laststatus = 3

---- set a default window border
-- This makes things like fzf-lua look weird so I'm disabling it for now
-- vim.o.winborder = "rounded"
