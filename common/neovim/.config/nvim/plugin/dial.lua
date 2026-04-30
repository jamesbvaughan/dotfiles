-- Enhanced increment/decrement functionality
--   https://github.com/monaqa/dial.nvim

vim.pack.add({ gh("monaqa/dial.nvim") })

local dial_map = function(command, mode)
	return function()
		require("dial.map").manipulate(command, mode)
	end
end

vim.keymap.set("n", "<c-a>", dial_map("increment", "normal"))
vim.keymap.set("n", "<c-x>", dial_map("decrement", "normal"))
vim.keymap.set("n", "g<c-a>", dial_map("increment", "gnormal"))
vim.keymap.set("n", "g<c-x>", dial_map("decrement", "gnormal"))
vim.keymap.set("v", "<c-a>", dial_map("increment", "visual"))
vim.keymap.set("v", "<c-x>", dial_map("decrement", "visual"))
vim.keymap.set("v", "g<c-a>", dial_map("increment", "gvisual"))
vim.keymap.set("v", "g<c-x>", dial_map("decrement", "gvisual"))

local augend = require("dial.augend")
require("dial.config").augends:register_group({
	default = {
		augend.integer.alias.decimal,
		augend.integer.alias.hex,
		augend.constant.alias.bool,
		augend.date.alias["%Y/%m/%d"],
		augend.date.alias["%Y-%m-%d"],
		augend.date.alias["%m/%d"],
		augend.date.alias["%H:%M"],
	},
})
