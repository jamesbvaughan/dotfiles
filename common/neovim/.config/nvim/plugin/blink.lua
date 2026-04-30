-- Completions
--   https://cmp.saghen.dev/

vim.pack.add({
	gh("rafamadriz/friendly-snippets"),
	gh("fang2hou/blink-copilot"),
	gh("zbirenbaum/copilot.lua"),
	{ src = gh("saghen/blink.cmp"), version = vim.version.range("1.x") },
})

---@type CopilotConfig
require("copilot").setup({
	suggestion = { enabled = false },
	panel = { enabled = false },
})

---@module 'blink.cmp'
---@type blink.cmp.Config
require("blink.cmp").setup({
	keymap = {
		["<A-y>"] = {
			function(cmp)
				cmp.show({ providers = { "copilot" } })
			end,
		},
	},

	completion = {
		ghost_text = {
			enabled = true,
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 0,
		},
	},

	sources = {
		providers = {
			copilot = {
				module = "blink-copilot",
				score_offset = 100,
				async = true,
			},
			lazydev = {
				module = "lazydev.integrations.blink",
				score_offset = 100,
			},
		},
		default = {
			"lazydev",
			"lsp",
			"path",
			"snippets",
			"buffer",
			"copilot",
		},
	},

	signature = { enabled = true },
})
