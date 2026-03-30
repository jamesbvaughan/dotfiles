-- A nice git interface
--   https://github.com/NeogitOrg/neogit

vim.pack.add({ gh('NeogitOrg/neogit') })

---@type NeogitConfig
require("neogit").setup({
  disable_hint = true,
  disable_insert_on_commit = false,
  graph_style = "kitty",
  signs = {
    -- { CLOSED, OPENED }
    hunk = { "", "" },
    item = { "▶", "▼" },
    section = { "▶", "▼" },
  },
})

vim.keymap.set("n", "<leader>g", function()
  require("neogit").open()
end, { desc = "Open neogit" })
