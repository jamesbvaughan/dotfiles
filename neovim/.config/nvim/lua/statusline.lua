-- luacheck: globals vim
local lsp_status = require('lsp-status')
local lualine = require('lualine')

lsp_status.config {
  show_filename = true,
}

lualine.setup {
  options = {
    theme = 'dracula-nvim',
    section_separators = '',
    component_separators = '|',
    extensions = {
      'quickfix',
    },
  },
  sections = {
    lualine_b = {
      'branch',
      'diff',
    },
    lualine_c = {
      {
        'filename',
        path = 1,
      },
    },
    lualine_x = {
      {
        'diagnostics',
        sources = {'nvim_diagnostic'}
      },
      'filetype',
    },
    lualine_y = {
      'location',
    },
    lualine_z = {
      lsp_status.status,
    },
  },
}
