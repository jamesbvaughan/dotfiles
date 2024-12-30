-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Install plugins
require("lazy").setup({
	-- Load plugins from ./plugins/*.lua
	import = "plugins",
}, {
	defaults = {
		lazy = true,
	},
	checker = {
		enabled = true,
		notify = false,
	},
	install = {
		colorscheme = { "catppuccin" },
	},
	change_detection = {
		notify = false,
	},
	performance = {
		cache = {
			enabled = true,
		},
		rtp = {
			-- Disable some built-in plugins that I don't use to shave off some ms
			-- from startup time.
			disabled_plugins = {
				"netrwPlugin",
				"gzip",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
