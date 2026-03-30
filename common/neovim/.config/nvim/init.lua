vim.loader.enable()

-- Helper for GitHub URLs (used by plugin/ files)
_G.gh = function(x) return 'https://github.com/' .. x end

-- PackChanged hooks (must be defined before any vim.pack.add)
vim.api.nvim_create_autocmd('PackChanged', { callback = function(ev)
  local name, kind = ev.data.spec.name, ev.data.kind
  if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
    if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
    vim.cmd('TSUpdate')
  end
  if name == 'tree-sitter-ghostty' and (kind == 'install' or kind == 'update') then
    if not ev.data.active then vim.cmd.packadd('tree-sitter-ghostty') end
    vim.system({ 'make', 'nvim_install' }, { cwd = ev.data.path })
  end
end })

require("options")
require("keymaps")
require("autocmds")
-- plugin/ files are auto-sourced after init.lua

if vim.g.neovide then
  require("gui")
end
