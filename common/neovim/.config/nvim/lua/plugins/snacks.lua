-- Config for snacks.nvim
--   https://github.com/folke/snacks.nvim

local function pick(name, opts)
	return function()
		local Snacks = require("snacks")
		Snacks.picker(name, opts)
	end
end

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,

	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		bufdelete = { enabled = true },
		dim = { enabled = true },
		gh = {
			enabled = true,
			wo = {
				spell = false,
			},
		},
		gitbrowse = { enabled = true },
		image = { enabled = true },
		indent = { enabled = true, animate = { enabled = false } },
		input = { enabled = true },
		notifier = { enabled = true },
		picker = {
			enabled = true,
			ui_select = true,
			win = {
				input = {
					keys = {
						-- Close the picker with Escape
						["<esc>"] = {
							---@diagnostic disable-next-line: assign-type-mismatch
							function(picker)
								picker:close()
							end,
							mode = { "n", "i" },
						},
					},
				},
			},
		},
		quickfile = { enabled = true },
		statuscolumn = { enabled = true },
		toggle = { enabled = true },
	},

	init = function()
		local Snacks = require("snacks")
		-- Reference for more toggle ideas:
		--   https://www.reddit.com/r/neovim/comments/1j55o9c/share_your_custom_toggles_using_snacks_toggle/
		Snacks.toggle.option("spell", { name = "󰓆 Spell Checking" }):map("<leader>ts")
		Snacks.toggle.option("wrap", { name = "󰖶 Wrap Long Lines" }):map("<leader>tw")
		Snacks.toggle.option("list", { name = "󱁐 List (Visible Whitespace)" }):map("<leader>tl")
		Snacks.toggle.diagnostics({ name = " Diagnostics" }):map("<leader>tD")
		Snacks.toggle.dim():map("<leader>td")
	end,

	keys = {
		{
			"<leader>d",
			function()
				require("snacks").bufdelete()
			end,
			desc = "Close the current buffer",
		},
		{
			"<leader>n",
			function()
				require("snacks").notifier.show_history()
			end,
			desc = "Show notification history",
		},
		{
			"gh",
			function()
				require("snacks").gitbrowse.open()
			end,
			desc = "Open the current file on the web",
		},

		-- Picker keymaps
		-- docs: https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
		{
			"<leader>ff",
			pick("files"),
			desc = "Find files",
		},
		{
			"<leader>fg",
			pick("grep", { hidden = true }),
			desc = "Live grep",
		},
		{
			"<leader>fb",
			pick("buffers"),
			desc = "Search open buffers",
		},
		{
			"<leader>fa",
			pick("git_files", { untracked = true }),
			desc = "Find files in current git repo",
		},
		{
			"<leader><leader>",
			pick("smart"),
			desc = "Smart file/buffer search",
		},
		{
			"<leader>fs",
			pick("grep_word"),
			desc = "Search for the word under the cursor",
		},
		{
			"<leader>ft",
			pick("treesitter"),
			desc = "Search treesitter symbols",
		},
		{
			"<leader>fc",
			pick("git_files", {
				cwd = "~/.dotfiles",
				untracked = true,
			}),
			desc = "Search dotfiles repo",
		},
		{
			"<leader>gp",
			pick("gh_pr"),
			desc = "Pull Requests",
		},
	},
}
