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
      "kyazdani42/nvim-web-devicons",
      "arkav/lualine-lsp-progress",
    },
    config = function()
      require("lualine").setup({
        options = {
          section_separators = "",
          component_separators = "",
          globalstatus = true,
        },
        extensions = {
          "quickfix",
          "fugitive",
        },
        sections = {
          lualine_c = {
            {
              "filename",
              path = 1,
            },
            "lsp_progress"
          },
          lualine_x = {
            "filetype",
          },
        },
      })
    end,
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
      -- Handle mutliple languages per file for picking comment strings
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    run = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "css",
          "go",
          "graphql",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "python",
          "ruby",
          "rust",
          "scss",
          "tsx",
          "typescript",
          "vim",
          "yaml",
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
        context_commentstring = {
          enable = true,
          enable_autocmd = false,
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

  -- Show context at the top of the butter
  use("nvim-treesitter/nvim-treesitter-context")

  -- Collection of configurations for built-in LSP client
  use("neovim/nvim-lspconfig")

  -- Pull JSON schemas from SchemsStore for use with jsonls
  use("b0o/schemastore.nvim")

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
        auto_open = true,
        height = 5,
        mode = "document_diagnostics",
        group = false,
        padding = false,
        indent_lines = false,
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
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "onsails/lspkind-nvim",
      "petertriho/cmp-git",
      "nvim-lua/plenary.nvim",
    },
  })

  -- Snippets
  use({
    "L3MON4D3/LuaSnip",
    requires = {
      -- "honza/vim-snippets",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_snipmate").lazy_load()
    end,
  })

  -- themes
  use({
    "Mofiqul/dracula.nvim",
    config = function()
      -- vim.g.dracula_italic_comment = true
      -- vim.g.dracula_transparent_bg = true
      -- vim.opt.termguicolors = true
      -- vim.cmd("colorscheme dracula")
    end,
  })
  use({
    "ellisonleao/gruvbox.nvim",
    config = function()
      vim.g.gruvbox_italic = 1
      vim.g.gruvbox_transparent_bg = 1
      vim.g.gruvbox_sign_column = "bg0"
      require("gruvbox").setup({
        overrides = {
          -- Set a color for copilot completion menu items
          CmpItemKindCopilot = { fg = "#98971A" }
        }
      })
    end,
  })
  use({
    "cormacrelf/dark-notify",
    config = function()
      require('dark_notify').run()
    end,
  })

  -- navigating files and other things
  use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })
  use({
    "nvim-telescope/telescope.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      local builtins = require("telescope.builtin")

      telescope.setup({})
      telescope.load_extension("fzf")

      vim.keymap.set("n", "<leader>ff", builtins.find_files)
      vim.keymap.set("n", "<leader>fg", builtins.live_grep)
      vim.keymap.set("n", "<leader>fb", builtins.buffers)
      vim.keymap.set("n", "<leader>fa", function()
        builtins.git_files({ show_untracked = true })
      end)
      vim.keymap.set("n", "<leader>fs", builtins.grep_string)
      vim.keymap.set("n", "<leader>ft", builtins.treesitter)
      vim.keymap.set("n", "<leader>fc", function()
        builtins.git_files({ cwd = "~/.dotfiles" })
      end)
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
  -- use("tpope/vim-commentary")
  use({
    'numToStr/Comment.nvim',
    requires = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function()
      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })
    end,
  })

  -- nice commands for working with git
  use({
    "tpope/vim-fugitive",
    requires = "tpope/vim-rhubarb",
    config = function()
      vim.keymap.set("", "gh", ":GBrowse<cr>")
      -- vim.keymap.set("n", "gs", ":Git<cr>")
      -- vim.keymap.set("n", "gl", ":Git log --pretty --oneline --abbrev-commit --graph -20 <cr>")
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
          diagnostics = true,
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
  -- use("ggandor/lightspeed.nvim")
  use({
    'ggandor/leap.nvim',
    config = function()
      require('leap').set_default_keymaps()
    end,
  })

  -- github copilot
  -- This is just necessary for setting up auth with `:Copilot setup`
  -- use("github/copilot.vim")
  use({
    "zbirenbaum/copilot.lua",
    event = { "VimEnter" },
    config = function()
      vim.defer_fn(function()
        require("copilot").setup({})
      end, 100)
    end
  })
  use({
    "zbirenbaum/copilot-cmp",
    module = "copilot_cmp",
  })

  -- nvim based git client
  use({
    'TimUntersberger/neogit',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      local neogit = require("neogit")

      neogit.setup()

      vim.keymap.set("n", "<leader>g", function()
        -- Open the neogit status buffer for the current buffer's repository
        neogit.open({ cwd = vim.fn.expand("%:p:h") })
      end
      )
    end,
  })

  -- highlight real colors inside nvim
  -- for example: "#123456"
  -- TODO: make this actually work
  use("norcalli/nvim-colorizer.lua")

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


-- Color things

vim.cmd("colorscheme gruvbox")
require("colorizer").setup({})

--- Remove the background color set by gruvbox
vim.api.nvim_set_hl(0, "Normal", {guibg = NONE, ctermbg = NONE})
vim.api.nvim_set_hl(0, "VertSplit", {guibg = NONE, ctermbg = NONE})
vim.api.nvim_set_hl(0, "SignColumn", {guibg = NONE, ctermbg = NONE})
