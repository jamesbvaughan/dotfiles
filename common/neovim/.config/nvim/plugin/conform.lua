-- Formatting plugin
--  https://github.com/stevearc/conform.nvim

vim.pack.add({ gh("stevearc/conform.nvim") })

---@type conform.setupOpts
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		rust = { "rustfmt" },
		sh = { "shfmt" },
		css = { "oxfmt" },
		graphql = { "oxfmt" },
		html = { "oxfmt" },
		javascript = { "oxlint", "oxfmt" },
		json = { "oxfmt" },
		markdown = { "oxfmt" },
		typescript = { "oxlint", "oxfmt" },
		typescriptreact = { "oxlint", "oxfmt" },
		yaml = { "oxfmt" },
	},
	format_on_save = { timeout_ms = 500, lsp_fallback = true },
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.keymap.set("n", "<leader>fm", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })

vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
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
