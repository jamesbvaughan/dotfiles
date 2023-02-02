local lsp = require("lsp-zero")
local cmp = require('cmp')
local luasnip = require('luasnip')

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp_next = cmp.mapping(function(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  elseif luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  elseif has_words_before() then
    cmp.complete()
  else
    fallback()
  end
end, { 'i', 's' })

local cmp_prev = cmp.mapping(function(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
  elseif luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    fallback()
  end
end, { 'i', 's' })

lsp.setup_nvim_cmp({
  sources = {
    { name = 'copilot' },
    { name = 'nvim_lua' },
    { name = 'path' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lsp', keyword_length = 3 },
    { name = 'buffer', keyword_length = 3 },
    { name = 'luasnip', keyword_length = 2 },
  },
  preselect = 'none',
  completion = {
    completeopt = 'menu,menuone,noinsert,noselect'
  },
  mapping = lsp.defaults.cmp_mappings({
    ['<Tab>'] = cmp_next,
    ['<C-n>'] = cmp_next,
    ['<S-Tab>'] = cmp_prev,
    ['<C-p>'] = cmp_prev,
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  }),
  -- window = {
  --   documentation = cmp.config.window.bordered(),
  -- },
  -- formatting = {
  --   format = function(entry, vim_item)
  --     if entry.source.name == "copilot" then
  --       vim_item.kind = " Copilot"
  --       -- vim_item.kind = ""
  --       vim_item.kind_hl_group = "CmpItemKindCopilot"
  --       return vim_item
  --     end
  --
  --     local formatter = require("lspkind").cmp_format({
  --       maxwidth = 50,
  --       mode = "symbol_text",
  --     })
  --
  --     return formatter(entry, vim_item)
  --   end
  -- },
  -- snippet = {
  --   expand = function(args)
  --     luasnip.lsp_expand(args.body)
  --   end,
  -- },
})

-- Completions in git commits
require("cmp_git").setup()
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' },
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/`
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':'
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Use nvim-autopairs to insert parens after completing a function name
cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done({ map_char = { tex = '' } }))
