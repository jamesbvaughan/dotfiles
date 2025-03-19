-- Completions
--   https://cmp.saghen.dev/

return {
	"saghen/blink.cmp",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"fang2hou/blink-copilot",

		-- github copilot
		{
			"zbirenbaum/copilot.lua",
			event = "InsertEnter",

			---@type copilot_config
			opts = {
				suggestion = { enabled = false },
				panel = { enabled = false },
			},
		},
	},
	version = "v0.*",

	---@type blink.cmp.Config
	opts = {
		keymap = {
			-- Manually invoke copilot completion
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
				auto_show_delay_ms = 500,
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
					-- make lazydev completions top priority (see `:h blink.cmp`)
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
	},
}
