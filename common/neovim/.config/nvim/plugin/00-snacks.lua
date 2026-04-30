-- Config for snacks.nvim
--   https://github.com/folke/snacks.nvim

vim.pack.add({ gh("folke/snacks.nvim") })

local Snacks = require("snacks")

---@type snacks.Config
Snacks.setup({
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
})

-- Toggles
Snacks.toggle.option("spell", { name = "󰓆 Spell Checking" }):map("<leader>ts")
Snacks.toggle.option("wrap", { name = "󰖶 Wrap Long Lines" }):map("<leader>tw")
Snacks.toggle.option("list", { name = "󱁐 List (Visible Whitespace)" }):map("<leader>tl")
Snacks.toggle.diagnostics({ name = " Diagnostics" }):map("<leader>tD")
Snacks.toggle.dim():map("<leader>td")

-- Keymaps
local function pick(name, opts)
	return function()
		Snacks.picker(name, opts)
	end
end

vim.keymap.set("n", "<leader>d", function()
	Snacks.bufdelete()
end, { desc = "Close the current buffer" })
vim.keymap.set("n", "<leader>n", function()
	Snacks.notifier.show_history()
end, { desc = "Show notification history" })
vim.keymap.set("n", "gh", function()
	Snacks.gitbrowse.open()
end, { desc = "Open the current file on the web" })
vim.keymap.set("n", "<leader>ff", pick("files"), { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", pick("grep", { hidden = true }), { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", pick("buffers"), { desc = "Search open buffers" })
vim.keymap.set("n", "<leader>fa", pick("git_files", { untracked = true }), { desc = "Find files in current git repo" })
vim.keymap.set("n", "<leader><leader>", pick("smart"), { desc = "Smart file/buffer search" })
vim.keymap.set("n", "<leader>fs", pick("grep_word"), { desc = "Search for the word under the cursor" })
vim.keymap.set("n", "<leader>ft", pick("treesitter"), { desc = "Search treesitter symbols" })
vim.keymap.set(
	"n",
	"<leader>fc",
	pick("git_files", { cwd = "~/.dotfiles", untracked = true }),
	{ desc = "Search dotfiles repo" }
)
vim.keymap.set("n", "<leader>gp", pick("gh_pr"), { desc = "Pull Requests" })
