local lspconfig = require('lspconfig')
local lsp_status = require('lsp-status')
local lsp_signature = require('lsp_signature')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

-- vim.lsp.set_log_level('debug')

vim.lsp.handlers['textDocument/publishDiagnostics'] =
  vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
      prefix = '●',
    },
    signs = true,
    underline = true,
    update_in_insert = false,
  })
lsp_status.register_progress()

local on_attach = function(client, bufnr)
  -- floating function signatures
  lsp_signature.on_attach({
    -- This (bind) is mandatory, otherwise border config won't get registered.
    bind = true,
    handler_opts = {
      border = 'single'
    }
  }, bufnr)

  lsp_status.on_attach(client, bufnr)

  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local function bufmap(combo, mapping)
    local opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', combo, mapping, opts)
  end

  bufmap('gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  bufmap('gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  bufmap('K', '<cmd>lua vim.lsp.buf.hover()<CR>')
  bufmap('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  -- bufmap('<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  bufmap('<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  bufmap('<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  bufmap('gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  bufmap('<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  -- bufmap('<leader>ca', '<cmd>lua vim.lsp.buf.range_code_action()<CR>')
  bufmap('<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
  bufmap('[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
  bufmap(']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
  bufmap('<leader>q', ':TroubleToggle<CR>')
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]

  -- Format on save
  vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

-- Set default client capabilities plus window/workDoneProgress for lsp-status
capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)

-- set the on_attach callback and capabilities for all servers
lspconfig.util.default_config = vim.tbl_extend(
  "force",
  lspconfig.util.default_config,
  {
    capabilities = capabilities,
    on_attach = on_attach,
  }
)

-- Enable the following language servers
lspconfig.pyright.setup({})
lspconfig.sourcekit.setup({})
lspconfig.flow.setup({})
lspconfig.bashls.setup({})
lspconfig.gopls.setup({
  settings = {
    gopls = {
      env = {
        GOPACKAGESDRIVER = './bin/gopackagesdriver.sh',
        CGO_ENABLED = 0,
      },
      ['build.directoryFilters'] = {
        '-bazel-bin',
        '-bazel-gocode',
        '-bazel-mypkg',
        '-bazel-out',
        '-bazel-testlogs',
      },
    },
  },
})

---- general linters
lspconfig.efm.setup({
  init_options = {
    documentFormatting = true,
  },
  filetypes = {
    'ruby',
    'go',
    'javascript',
    'lua',
    'puppet',
    'yaml',
    'markdown',
    'sh',
    'python',
  },
  settings = {
    rootMarkers = {".git/"},
    -- logLevel = 1,
    languages = {
      ruby = {
        {
          lintCommand =
            'bundle exec rubocop -s ${INPUT} -f simple --cache true',
          lintStdin = true,
          lintIgnoreExitCode = true,
          lintFormats = {
            '%t: %l:  %c: %m',
            '%t: %l: %c: %m',
          },
        },
      },
      go = {
        {
          formatCommand = 'goimports',
          formatStdin = true,
        }
      },
      javascript = {
        {
          lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
          lintStdin = true,
          lintFormats = {"%f:%l:%c: %m"},
          lintIgnoreExitCode = true,
          formatCommand =
            "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
          formatStdin = true
        },
      },
      lua = {
        {
          lintCommand =
            'luacheck - --formatter plain --globals vim --max-line-length 80',
          lintStdin = true,
          lintIgnoreExitCode = true,
          lintFormats = {
            '%f:%l:%c: %m',
          },
        },
      },
      puppet = {
        {
          lintCommand =
            "puppet-lint --log-format="..
            "'%{filename}:%{line}:%{column}:%{kind}: %{message} (%{check})'",
          lintStdin = false,
          lintIgnoreExitCode = true,
          lintFormats = {
            '%f:%l:%c:%trror: %m',
            '%f:%l:%c:%tarning: %m',
          },
        },
      },
      yaml = {
        {
          lintCommand = 'yamllint -f parsable -',
          lintStdin = true,
          lintIgnoreExitCode = true,
          lintFormats = {
            '%f:%l:%c: [%trror] %m',
            '%f:%l:%c: [%tarning] %m',
          },
        },
      },
      markdown = {
        {
          lintCommand = 'markdownlint -s',
          lintStdin = true,
          lintIgnoreExitCode = true,
          lintFormats = {
            '%f:%l:%c %m',
            '%f:%l %m',
          },
        },
      },
      sh = {
        {
          lintCommand = 'shellcheck -f gcc -x',
          lintSource = 'shellcheck',
          lintIgnoreExitCode = true,
          lintFormats = {
            '%f:%l:%c: %trror: %m',
            '%f:%l:%c: %tarning: %m',
            '%f:%l:%c: %tote: %m',
          },
        },
        {
          formatCommand = 'shfmt -ci -s -bn -i 2',
          formatStdin = true,
        },
      },
      python = {
        {
          formatCommand = 'autopep8 -',
          formatStdin = true,
        },
      },
    },
  },
})

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

for type, icon in pairs(signs) do
  local hl = "LspDiagnosticsSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
