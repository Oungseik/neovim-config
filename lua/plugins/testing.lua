return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "arthur944/neotest-bun",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-bun"),
        require("rustaceanvim.neotest"),
      },
    })
  end,
  keys = {
    { "<leader>t",  "<Nop>",                                 desc = "+Tests",   silent = true },
    { "<leader>tr", ":lua require('neotest').run.run()<cr>", desc = "Run Test", silent = true },
    {
      "<leader>tf",
      ":lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
      desc = "Run Test File",
      silent = true,
    },
    { "<leader>td", ":lua require('neotest').run.run({strategy = 'dap'})<cr>", desc = "Debug Test", silent = true },
    { "<leader>ts", ":lua require('neotest').run.stop()<cr>",                  desc = "Stop",       silent = true },
    {
      "<leader>tS",
      ":lua require('neotest').summary.toggle()<cr>",
      desc = "Summary",
      silent = true,
    },
  },
}
