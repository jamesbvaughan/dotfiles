-- Enhanced increment/decrement functionality
--   https://github.com/monaqa/dial.nvim

local dial_map = function(command, mode)
	return function()
		require("dial.map").manipulate(command, mode)
	end
end

return {
	"monaqa/dial.nvim",
	keys = {
		{ "<c-a>", dial_map("increment", "normal"), mode = "n" },
		{ "<c-x>", dial_map("decrement", "normal"), mode = "n" },
		{ "g<c-a>", dial_map("increment", "gnormal"), mode = "n" },
		{ "g<c-x>", dial_map("decrement", "gnormal"), mode = "n" },
		{ "<c-a>", dial_map("increment", "visual"), mode = "v" },
		{ "<c-x>", dial_map("decrement", "visual"), mode = "v" },
		{ "g<c-a>", dial_map("increment", "gvisual"), mode = "v" },
		{ "g<c-x>", dial_map("decrement", "gvisual"), mode = "v" },
	},
	config = function()
		local augend = require("dial.augend")
		require("dial.config").augends:register_group({
			default = {
				augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
				augend.integer.alias.hex, -- nonnegative hex number (0x01, 0x1a1f, etc.)
				augend.constant.alias.bool, -- boolean value (true <-> false)
				augend.date.alias["%Y/%m/%d"], -- date (2022/02/19, etc.)
				augend.date.alias["%Y-%m-%d"], -- date (2022-02-19, etc.)
				augend.date.alias["%m/%d"], -- date (02/19, etc.)
				augend.date.alias["%H:%M"], -- time (23:59, etc.)
			},
		})
	end,
}
