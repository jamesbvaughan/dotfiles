local lsp_zero = require("lsp-zero")
local cmp = require("cmp")
local luasnip = require("luasnip")

local has_words_before = function()
	if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
		return false
	end
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

local cmp_next = cmp.mapping(function(fallback)
	if cmp.visible() and has_words_before() then
		cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
	elseif luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
	else
		fallback()
	end
end, { "i", "s" })

local cmp_prev = cmp.mapping(function(fallback)
	if cmp.visible() then
		cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
	elseif luasnip.jumpable(-1) then
		luasnip.jump(-1)
	else
		fallback()
	end
end, { "i", "s" })

cmp.setup({
	sources = cmp.config.sources({
		{ name = "copilot" },
		{ name = "nvim_lua" },
		{ name = "nvim_lsp_signature_help" },
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	}, {
		{ name = "path" },
		{ name = "buffer" },
	}),
	preselect = "none",
	completion = {
		completeopt = "menu,menuone,noinsert,noselect",
	},
	formatting = lsp_zero.cmp_format(),
	mapping = cmp.mapping.preset.insert({
		-- ["<Tab>"] = cmp_next,
		["<C-n>"] = cmp_next,
		-- ["<S-Tab>"] = cmp_prev,
		["<C-p>"] = cmp_prev,
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		}),
		-- scroll up and down the documentation window
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
	}),
	-- formatting = {
	--     format = require("lspkind").cmp_format({
	--         preset = "codicons",
	--         symbol_map = {
	--             Copilot = "",
	--         },
	--     }),
	-- },
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
})

-- Completions in git commits
require("cmp_git").setup()
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "cmp_git" },
	}, {
		{ name = "buffer" },
	}),
})

-- Use buffer source for `/`
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':'
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

-- Use nvim-autopairs to insert parens after completing a function name
cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done({ map_char = { tex = "" } }))
