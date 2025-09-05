-- Formatting plugin
--  https://github.com/stevearc/conform.nvim

local prettier_formatters = { "prettierd", "prettier", stop_after_first = true }

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>fm",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			desc = "Format buffer",
		},
	},

	---@type conform.setupOpts
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			rust = { "rustfmt" },
			sh = { "shfmt" },
			css = prettier_formatters,
			graphql = prettier_formatters,
			html = prettier_formatters,
			javascript = prettier_formatters,
			json = prettier_formatters,
			markdown = prettier_formatters,
			typescript = prettier_formatters,
			typescriptreact = prettier_formatters,
			yaml = prettier_formatters,
		},
		format_on_save = { timeout_ms = 500, lsp_fallback = true },
	},

	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				-- FormatDisable! will disable formatting just for this buffer
				vim.b.disable_autoformat = true
			else
				vim.g.disable_autoformat = true
			end
		end, {
			desc = "Disable autoformat-on-save",
			bang = true,
		})
		vim.api.nvim_create_user_command("FormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
		end, {
			desc = "Re-enable autoformat-on-save",
		})
	end,
}
