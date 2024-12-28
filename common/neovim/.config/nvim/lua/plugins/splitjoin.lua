return {
	"bennypowers/splitjoin.nvim",
	lazy = true,
	keys = {
		{
			"gJ",
			function()
				require("splitjoin").join()
			end,
			desc = "Join the object under cursor",
		},
		{
			"gS",
			function()
				require("splitjoin").split()
			end,
			desc = "Split the object under cursor",
		},
	},
}
