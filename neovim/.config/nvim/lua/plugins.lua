-- Bootstrap packer

local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd 'packadd packer.nvim'
end


-- Load plugins with packer

require('packer').startup(function(use)
  -- Better integration between nvim and tmux
  use 'christoomey/vim-tmux-navigator'

  -- Use packer to manage itself
  use 'wbthomason/packer.nvim'

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

  -- Collection of configurations for built-in LSP client
  use 'neovim/nvim-lspconfig'

  -- Install nvim-cmp, and buffer source as a dependency
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-buffer",
    }
  }

  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp

  -- dracula theme
  use 'Mofiqul/dracula.nvim'

  -- navigating files and other things
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- a c port of fzf for telescope
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make'
  }

  -- common lisp stuff
  use {
    'vlime/vlime',
    rtp = 'vim/'
  }

  -- nice bindings for working with surrounds
  use 'tpope/vim-surround'

  -- nice bindings for working with comments
  use 'tpope/vim-commentary'

  -- nice commands for working with git
  use 'tpope/vim-fugitive'

  -- nice commands for working with git
  use 'tpope/vim-rhubarb'

  -- buffer line
  use {
    'akinsho/bufferline.nvim',
    requires = 'kyazdani42/nvim-web-devicons'
  }
end)


-- Plugin settings

--- lualine.nvim
require('lualine').setup {
  options = {
    theme = 'dracula',
    section_separators = '',
    component_separators = '',
    extensions = {
      'quickfix',
    },
  },
  sections = {
    lualine_c = {
      {
        'filename',
        path = 1,
      },
      'diff',
    },
    lualine_x = {
      {
        'diagnostics',
        sources = {'nvim_lsp'}
      },
      'filetype',
    },
  },
}

-- bufferline.nvim
require('bufferline').setup{
  options = {
    show_buffer_close_icons = false,
    show_close_icon = false,
    always_show_bufferline = false,
    diagnostics = 'nvim_lsp',
  }
}

--- nvim-treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = 'maintained',
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
}

--- nvim-lspconfig

---- python - pyright
require('lspconfig').pyright.setup{}

---- swift - sourcekit
require('lspconfig').sourcekit.setup{}

---- javascript - tsserver
-- require('lspconfig').tsserver.setup{}

---- javascript - flow
local flow_opts = {}
-- local local_flow = 'node_modules/.bin/flow'
-- if vim.fn.glob(local_flow) ~= "" then
--   flow_opts.cmd = { local_flow, "lsp" }
-- end
require('lspconfig').flow.setup(flow_opts)

---- ruby - sorbet
local sorbet_opts = {}
if vim.fn.glob("scripts/bin/typecheck") ~= "" then
  -- use 'pay exec' when in pay-server
  sorbet_opts.cmd = { "pay", "exec", "scripts/bin/typecheck", "--lsp" }
end
require('lspconfig').sorbet.setup(sorbet_opts)

---- go - gopls
require('lspconfig').gopls.setup{}

---- general linters
require('lspconfig').efm.setup{
  filetypes = {
    'ruby',
    'go'
  },
  settings = {
    rootMarkers = {".git/"},
    languages = {
      ruby = {
        {
          lintCommand = 'bundle exec rubocop',
          lintStdin = true,
        },
      },
      go = {
        {
          formatCommand = 'goimports',
          formatStdin = true,
        }
      },
    },
  },
}

-- Format on save
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()]]

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- nvim-cmp setup
local cmp = require('cmp')
cmp.setup {
  documentation = {
		border = 'rounded',
	},
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<Tab>'] = function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), 'n')
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, true, true), 'n')
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  },
}

-- telescope setup
require('telescope').setup {}
require('telescope').load_extension('fzf')
