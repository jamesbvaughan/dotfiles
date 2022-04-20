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
		requires = {
			{
				"kyazdani42/nvim-web-devicons",
				opt = true,
			},
      'arkav/lualine-lsp-progress',
		},
	})

	-- AST parsing backend
	use({
		"nvim-treesitter/nvim-treesitter",
		requires = {
			-- Additional text objects
			"nvim-treesitter/nvim-treesitter-textobjects",
			-- auto-complete html tags
			"windwp/nvim-ts-autotag",
			-- auto-add "end" in ruby and similar languages
			"RRethy/nvim-treesitter-endwise",
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
				autotag = {
					enable = true,
				},
				endwise = {
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

      vim.opt.foldlevel = 20
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
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
				auto_close = true,
				mode = "document_diagnostics",
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
			"hrsh7th/cmp-cmdline",
			"onsails/lspkind-nvim",
		},
	})

	-- Snippets
	use({
		"L3MON4D3/LuaSnip",
		requires = {
			"honza/vim-snippets",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_snipmate").lazy_load()
		end,
	})

	-- Show function signatures as you type
	use({
		"ray-x/lsp_signature.nvim",
    config = function()
      require('lsp_signature').setup({
        -- This (bind) is mandatory, otherwise border config won't get registered.
        -- bind = true,
        -- handler_opts = {
        --   border = "single",
        -- },
      })
    end,
	})

	-- themes
	use({
		"Mofiqul/dracula.nvim",
		config = function()
			vim.g.dracula_italic_comment = true
			-- vim.g.dracula_transparent_bg = true
			vim.opt.termguicolors = true
			vim.cmd("colorscheme dracula")
		end,
	})

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

	-- auto pairs
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
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

	-- visualize indentation
	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("indent_blankline").setup({})
		end,
	})

	-- quick navigation within a file
	use("ggandor/lightspeed.nvim")

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
