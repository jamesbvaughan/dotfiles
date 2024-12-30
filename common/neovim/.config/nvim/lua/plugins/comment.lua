-- Nice bindings for working with comments
--   https://github.com/numToStr/Comment.nvim
--
-- This is built into neovim by default now. The only reason I'm keeping this
-- plugin around is for commenting jsx

return {
	"numToStr/Comment.nvim",
	event = { "InsertEnter" },
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	config = function()
		---@diagnostic disable-next-line: missing-fields
		require("Comment").setup({
			pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
		})
	end,
}
