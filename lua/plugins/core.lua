return {
  { "folke/tokyonight.nvim", lazy = false, priority = 1000, opts = {} },

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
}
