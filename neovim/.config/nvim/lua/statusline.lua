local lsp_status = require('lsp-status')

lsp_status.config {
  show_filename = true,
}

require('lualine').setup {
  options = {
    theme = 'dracula',
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
        sources = {'nvim_lsp'}
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
