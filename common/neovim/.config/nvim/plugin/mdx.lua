-- MDX highlighting
--   https://github.com/davidmh/mdx.nvim
--
-- Registers the `mdx` filetype, parses it with the markdown treesitter parser
-- and injects TSX into import/export lines and JSX blocks. It sets itself up
-- from after/plugin, so there's no setup() call.
-- The mdx_analyzer language server is configured in lspconfig.lua.

vim.pack.add({ gh("davidmh/mdx.nvim") })
