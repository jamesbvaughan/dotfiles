-- Nice bindings for working with comments
--   https://github.com/numToStr/Comment.nvim
--
-- This is built into neovim by default now. The only reason I'm keeping this
-- plugin around is for commenting jsx

vim.pack.add({
	gh("JoosepAlviste/nvim-ts-context-commentstring"),
	gh("numToStr/Comment.nvim"),
})

---@diagnostic disable-next-line: missing-fields
require("Comment").setup({
	pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})
