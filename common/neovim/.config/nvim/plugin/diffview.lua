vim.pack.add({ gh('sindrets/diffview.nvim') })

---@type DiffviewConfig
require("diffview").setup({
  enhanced_diff_hl = true,
  keymaps = {
    file_panel = {
      { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
    },
    file_history_panel = {
      { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
    },
  },
})

vim.keymap.set("n", "<leader>h", function()
  vim.cmd.DiffviewFileHistory("%")
end, { desc = "Open diffview for the current file" })
