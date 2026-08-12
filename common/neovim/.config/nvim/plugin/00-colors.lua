-- `colorscheme kanagawa` resolves to the variant configured for the current
-- `background`, so both callbacks use the same name.
local function setDark()
  vim.opt.background = "dark"
  vim.cmd("colorscheme kanagawa")
end

local function setLight()
  vim.opt.background = "light"
  vim.cmd("colorscheme kanagawa")
end

vim.pack.add({
  { src = gh("rebelot/kanagawa.nvim"), name = "kanagawa" },
  gh("f-person/auto-dark-mode.nvim"),
})

---@type KanagawaConfig
require("kanagawa").setup({
  -- dragon is the near-black variant (bg #181616); lotus is its light pair.
  background = { dark = "dragon", light = "lotus" },
  commentStyle = { italic = true },
  keywordStyle = { italic = true },
  statementStyle = { bold = true },
  terminalColors = true,
  colors = {
    theme = {
      all = {
        ui = {
          -- Turn off the default gutter background
          bg_gutter = "none"
        }
      },
    },
  },
  overrides = function(colors)
    local theme = colors.theme
    return {
      SnacksIndent = { fg = theme.ui.bg_p2 },
      SnacksIndentScope = { fg = theme.ui.nontext },
      BlinkCmpMenu = { bg = theme.ui.bg_m1 },
    }
  end,
})

setDark()

---@type AutoDarkModeOptions
require("auto-dark-mode").setup({
  update_interval = 1000,
  set_dark_mode = setDark,
  set_light_mode = setLight,
})
