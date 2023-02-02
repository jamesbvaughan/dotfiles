return {
  {
    "ellisonleao/gruvbox.nvim",
    opts = {
      overrides = {
        SignColumn = { bg = "NONE" },
        GruvboxRedSign = { bg = "NONE" },
        GruvboxYellowSign = { bg = "NONE" },
        GruvboxBlueSign = { bg = "NONE" },
        GruvboxAquaSign = { bg = "NONE" },
        GruvboxGreenSign = { bg = "NONE" },
        CmpItemKindCopilot = { fg = "#98971A" }
      }
    },
    init = function()
      vim.cmd("colorscheme gruvbox")
    end,
  },
}
