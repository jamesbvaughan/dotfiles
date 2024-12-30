-- Completions
--   https://cmp.saghen.dev/

return {
	"saghen/blink.cmp",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"giuxtaposition/blink-cmp-copilot",
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
			menu = {
				draw = {
					columns = {
						{ "label", "label_description", gap = 1 },
						{ "kind_icon", "kind", gap = 1 },
					},
				},
				auto_show = function(ctx)
					return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
				end,
			},
			documentation = {
				auto_show = true,
			},
		},

		sources = {
			providers = {
				copilot = {
					name = "copilot",
					module = "blink-cmp-copilot",
					score_offset = 100,
					async = true,

					-- This is only necessary to get item labels
					transform_items = function(_, items)
						local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
						local kind_idx = #CompletionItemKind + 1
						CompletionItemKind[kind_idx] = "Copilot"
						for _, item in ipairs(items) do
							item.kind = kind_idx
						end
						return items
					end,
				},
				lazydev = {
					name = "LazyDev",
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
