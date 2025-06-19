return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.enable("ts_ls")
      vim.lsp.enable("lua_ls")
      vim.lsp.enable("prismals")
    end,
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false, -- this plugin is already lazy
  },
}
