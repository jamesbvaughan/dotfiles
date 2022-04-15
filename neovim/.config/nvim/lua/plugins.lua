-- luacheck: globals vim

-- Bootstrap packer

local packer_bootstrap
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	packer_bootstrap = vim.fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

-- Load plugins with packer

require("packer").startup(function(use)
	-- Use packer to manage itself
	use("wbthomason/packer.nvim")

	-- Better integration between nvim and tmux
	use("christoomey/vim-tmux-navigator")

	-- A fancy statusline
	use({
		"hoob3rt/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

	-- AST parsing backend
	use({
		"nvim-treesitter/nvim-treesitter",
		requires = {
			-- Additional text objects
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		run = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = "all",
				ignore_install = {
					"phpdoc", -- This was throwing errors during installation
				},
				highlight = {
					enable = true,
				},
				indent = {
					enable = true,
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
				},
			})
		end,
	})

	-- Collection of configurations for built-in LSP client
	use("neovim/nvim-lspconfig")

	-- LSP plugin for non-LSP sources, like linters
	use({
		"jose-elias-alvarez/null-ls.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"neovim/nvim-lspconfig",
		},
	})

	-- Quickfix list for lsp diagnostics
	use({
		"folke/trouble.nvim",
		requires = {
			"kyazdani42/nvim-web-devicons",
		},
		config = function()
			require("trouble").setup({
				auto_open = true,
				auto_close = true,
				mode = "document_diagnostics",
				use_lsp_diagnostic_signs = false,
			})
		end,
	})

	-- Stabilize the trouble window
	use({
		"luukvbaal/stabilize.nvim",
		config = function()
			require("stabilize").setup({
				-- This is necessary to get stabilize to work in some cases.
				-- See https://github.com/luukvbaal/stabilize.nvim#note
				nested = "QuickFixCmdPost,DiagnosticChanged *",
			})
		end,
	})

	-- Install nvim-cmp, and buffer source as a dependency
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-path",
			"onsails/lspkind-nvim",
			"honza/vim-snippets",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
	})

	use("ray-x/lsp_signature.nvim")

	use("nvim-lua/lsp-status.nvim")

	-- themes
	use("Mofiqul/dracula.nvim")

	-- navigating files and other things
	use({
		"nvim-telescope/telescope.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({})

			vim.keymap.set("n", "ff", ":Telescope find_files<cr>")
			vim.keymap.set("n", "fg", ":Telescope live_grep<cr>")
			vim.keymap.set("n", "fb", ":Telescope buffers<cr>")
			vim.keymap.set("n", "fa", ":Telescope git_files<cr>")
		end,
	})

	-- common lisp environment
	use({
		"vlime/vlime",
		rtp = "vim/",
	})

	-- nice bindings for working with surrounds
	use("tpope/vim-surround")
	use("tpope/vim-repeat")

	-- nice bindings for working with comments
	use("tpope/vim-commentary")

	-- nice commands for working with git
	use({
		"tpope/vim-fugitive",
		requires = "tpope/vim-rhubarb",
		config = function()
			vim.keymap.set("", "gh", ":GBrowse<cr>")
			vim.keymap.set("n", "gs", ":Git<cr>")
			vim.keymap.set("n", "gl", ":Git log --pretty --oneline --abbrev-commit --graph -20 <cr>")
		end,
	})

	-- git signs
	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				current_line_blame = true,
				current_line_blame_opts = {
					delay = 500,
				},
			})
		end,
	})

	-- buffer line
	use({
		"akinsho/bufferline.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("bufferline").setup({
				options = {
					show_buffer_close_icons = false,
					show_close_icon = false,
					always_show_bufferline = false,
					diagnostics = "nvim_lsp",
				},
			})
		end,
	})

	-- puppet language niceties
	use("rodjek/vim-puppet")

	-- undo tree
	use({
		"mbbill/undotree",
		config = function()
			vim.keymap.set("n", "U", ":UndotreeToggle<cr>")
		end,
	})

	-- handlebars support
	use("mustache/vim-mustache-handlebars")

	-- which-key
	use({
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({})
		end,
	})

	pcall(function()
		require("extra_packages")(use)
	end)

	-- Automatically set up configuration after cloning packer.nvim
	if packer_bootstrap then
		require("packer").sync()
	end
end)

require("lsp")
require("completion")
require("statusline")
