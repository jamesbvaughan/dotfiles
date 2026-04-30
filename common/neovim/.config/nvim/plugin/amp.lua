-- Amp Plugin
vim.pack.add({
	{ src = gh("sourcegraph/amp.nvim") },
})

require("amp").setup({ auto_start = true, log_level = "info" })
