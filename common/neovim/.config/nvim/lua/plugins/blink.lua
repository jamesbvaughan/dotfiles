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

			-- TODO: Contribute a change to this plugin to provide a non-strict
			-- version of this type, as in this example:
			-- https://github.com/Saghen/blink.cmp/blob/main/lua/blink/cmp/config/types_partial.lua
			--
			---@type CopilotConfig
			opts = {
				suggestion = { enabled = false },
				panel = { enabled = false },
			},
		},
	},
	version = "v1.*",

	---@module 'blink.cmp'
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
				-- auto_show_delay_ms = 500,
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
