return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = { --[[ things you want to change go here]]
    direction = "float",
    float_opts = { border = "rounded" },
    shading_factor = 2,
    size = 10,
  },

  keys = {
    { "<M-3>", "<Cmd>ToggleTerm name=Floating_Terminal<CR>", desc = "Toggle Term" },
    { "<M-3>", "<Cmd>ToggleTerm name=Floating_Terminal<CR>", mode = "i",          desc = "Toggle Term" },
    { "<M-3>", "<Cmd>ToggleTerm<CR>", mode = "t",          desc = "Toggle Term" },
  },
}
