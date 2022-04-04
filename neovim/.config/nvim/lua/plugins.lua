-- luacheck: globals vim
local utils = require('utils')
local map = utils.map

-- Bootstrap packer

local packer_bootstrap
local install_path =
  vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({
    'git', 'clone', '--depth', '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  })
end


-- Load plugins with packer

require('packer').startup(function(use)
  -- Use packer to manage itself
  use 'wbthomason/packer.nvim'

  -- Better integration between nvim and tmux
  use 'christoomey/vim-tmux-navigator'

  -- A fancy statusline
  use {
    'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true}
  }

  -- AST parsing backend
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  -- Additional text objects from treesitter
  use 'nvim-treesitter/nvim-treesitter-textobjects'

  -- Collection of configurations for built-in LSP client
  use 'neovim/nvim-lspconfig'

  -- LSP plugin for non-LSP sources, like linters
  use {
    'jose-elias-alvarez/null-ls.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'neovim/nvim-lspconfig',
    },
  }

  -- Quickfix list for lsp diagnostics
  use {
    'folke/trouble.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
  }

  -- stabilize the trouble window
  use 'luukvbaal/stabilize.nvim'

  -- Install nvim-cmp, and buffer source as a dependency
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-path',
      'onsails/lspkind-nvim',
      'honza/vim-snippets',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    }
  }

  use 'ray-x/lsp_signature.nvim'

  use 'nvim-lua/lsp-status.nvim'

  -- themes
  use 'Mofiqul/dracula.nvim'
  use 'joshdick/onedark.vim'

  -- colors for lsp for older colorschemes
  use 'folke/lsp-colors.nvim'

  -- navigating files and other things
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
  }
  -- a c port of fzf for telescope
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make',
  }

  -- common lisp environment
  use {
    'vlime/vlime',
    rtp = 'vim/'
  }

  -- nice bindings for working with surrounds
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'

  -- nice bindings for working with comments
  use 'tpope/vim-commentary'

  -- nice commands for working with git
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'

  -- buffer line
  use {
    'akinsho/bufferline.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
  }

  -- puppet language niceties
  use 'rodjek/vim-puppet'

  -- undo tree
  use 'mbbill/undotree'

  -- handlebars support
  use 'mustache/vim-mustache-handlebars'


  pcall(function() require('extra_packages')(use) end)

  -- Automatically set up configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)


-- telescope
require('telescope').setup {}
require('telescope').load_extension('fzf')

map('n', 'ff', ':Telescope find_files<cr>')
map('n', 'fg', ':Telescope live_grep<cr>')
map('n', 'fb', ':Telescope buffers<cr>')
map('n', 'fa', ':Telescope git_files<cr>')


-- fugitive and rhubarb
map('', 'gh', ':GBrowse<cr>')
map('n', 'gs', ':Git<cr>')
map('n', 'gl', ':Git log --pretty --oneline --abbrev-commit --graph -20 <cr>')


-- undotree
map('n', 'U', ':UndotreeToggle<cr>')


-- treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = 'maintained',
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
}


-- trouble
require('trouble').setup {
  auto_open = true,
  auto_close = true,
  mode = 'document_diagnostics',
  use_lsp_diagnostic_signs = false,
}


-- stabilize
require('stabilize').setup()


-- bufferline
require('bufferline').setup {
  options = {
    show_buffer_close_icons = false,
    show_close_icon = false,
    always_show_bufferline = false,
    diagnostics = 'nvim_lsp',
  }
}


require('lsp')
require('completion')
require('statusline')
