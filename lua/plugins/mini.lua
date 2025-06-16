return {
  {
    "echasnovski/mini.bufremove",
    version = false,
    event = "BufEnter",
    config = function()
      require("mini.bufremove").setup({})
    end,
    keys = {
      {
        "<leader>c",
        ":lua if not pcall(function () MiniBufremove.delete(0, false) end) then vim.cmd.quit() end<cr>",
        desc = "Close Buffer",
        silent = true,
      },
    },
  },

  {
    "echasnovski/mini.pairs",
    version = "*",
    config = function()
      require("mini.pairs").setup({})
    end,
  },
}
