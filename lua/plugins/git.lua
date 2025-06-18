return {
  {
    "lewis6991/gitsigns.nvim",
    lazy = true,
    name = "gitsigns",
    event = "BufEnter",
    opts = {
      trouble = false,
      current_line_blame = false,
      signs = {
        delete = { text = "" },
        topdelete = { text = "" },
      },
    },
    keys = {
      { "<leader>g",  "<Nop>",                              desc = "+Git" },
      { "<leader>gj", ":Gitsigns nav_hunk next<cr>",        desc = "Next Hunk",    silent = true },
      { "<leader>gk", ":Gitsigns nav_hunk prev<cr>",        desc = "Prev Hunk",    silent = true },
      { "<leader>gl", ":Gitsigns blame_line<cr>",           desc = "Blame",        silent = true },
      { "<leader>gL", ":Gitsigns blame_line full=true<cr>", desc = "Blame (full)", silent = true },
      { "<leader>gp", ":Gitsigns preview_hunk<cr>",         desc = "Preview",      silent = true },
      { "<leader>gr", ":Gitsigns reset_hunk<cr>",           desc = "Reset Hunk",   silent = true },
      { "<leader>gR", ":Gitsigns reset_buffer<cr>",         desc = "Reset Buffer", silent = true },
      { "<leader>gs", ":Gitsigns stage_hunk<cr>",           desc = "Stage Hunk",   silent = true },
      { "<leader>gS", ":Gitsigns stage_buffer<cr>",         desc = "Stage Buffer", silent = true },
      { "<leader>gu", ":Gitsigns undo_stage_hunk<cr>",      desc = "Unstage Hunk", silent = true },
    },
  },
  {
    "sindrets/diffview.nvim",
    keys = {
      { "<leader>gd", ":DiffviewClose<cr>", desc = "Diff Close", silent = true },
      { "<leader>gD", ":DiffviewOpen<cr>",  desc = "Diff Open",  silent = true },
    },
  },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = "BufEnter",
    config = true,
    keys = {
      { "<leader>gn", ":GitConflictNextConflict<cr>", desc = "Next Conflict", silent = true },
      { "<leader>gp", ":GitConflictPrevConflict<cr>", desc = "Prev Conflict", silent = true },
    },
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    keys = {
      { "<leader>gN", ":Neogit<cr>", desc = "Neogit", silent = true },
    },
  },
}
