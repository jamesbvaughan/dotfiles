vim.pack.add({
	{ src = gh("nvim-mini/mini.nvim") },
})

require("mini.icons").setup()

-- Let plugins that expect nvim-web-devicons use mini.icons instead
MiniIcons.mock_nvim_web_devicons()
