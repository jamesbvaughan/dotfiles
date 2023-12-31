return {
  {
    "ellisonleao/gruvbox.nvim",
    enabled = true,
    lazy = false,
    priority = 100,
    opts = {
      transparent_mode = true,
      overrides = {
        -- SignColumn = { bg = "NONE" },
        -- GruvboxRedSign = { bg = "NONE" },
        -- GruvboxYellowSign = { bg = "NONE" },
        -- GruvboxBlueSign = { bg = "NONE" },
        -- GruvboxAquaSign = { bg = "NONE" },
        -- GruvboxGreenSign = { bg = "NONE" },
        CmpItemKindCopilot = { fg = "#98971A" }
      }
    },
    init = function()
      vim.cmd("colorscheme gruvbox")
    end,
  },

  {
    "hylophile/flatwhite.nvim",
    enabled = true,
    lazy = false,
    priority = 100,
    opts = {
      transparent_bg = true,
    },
  },

  -- {
  --   "jamesbvaughan/flexoki-nvim",
  --   name = "flexoki",
  --   lazy = false,
  --   priority = 100,
  --   init = function()
  --     vim.cmd("colorscheme flexoki")
  --   end,
  -- },

  {
    "f-person/auto-dark-mode.nvim",
    enabled = true,
    lazy = false,
    priority = 90,
    opts = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.api.nvim_set_option('background', 'dark')
        vim.cmd('colorscheme gruvbox')
      end,
      set_light_mode = function()
        vim.api.nvim_set_option('background', 'light')
        vim.cmd('colorscheme flatwhite')
      end,
    },
    init = function()
      require('auto-dark-mode').init()
    end,
  }
}
