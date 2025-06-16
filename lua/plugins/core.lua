return {
  -- { "folke/tokyonight.nvim", lazy = false, priority = 1000,     opts = {} },
  { "catppuccin/nvim",      lazy = false,      name = "catppuccin", priority = 1000 },

  {
    "nvim-treesitter/nvim-treesitter",
    name = "nvim-treesitter",
    event = "BufEnter",
    opts = {
      ensure_installed = { "lua" },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },

  { "folke/which-key.nvim", event = "VeryLazy" },

  {
    "kevinhwang91/nvim-ufo",
    event = "BufNew",
    dependencies = { "kevinhwang91/promise-async" },
    config = function()
      require("ufo").setup()
    end,
  },
}
