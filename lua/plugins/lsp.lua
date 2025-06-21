return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.enable("ts_ls")
      vim.lsp.enable("lua_ls")
      vim.lsp.enable("prismals")
      vim.lsp.enable("jsonls")
      vim.lsp.enable("nil_ls")
      vim.lsp.enable("gopls")
    end,
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false, -- this plugin is already lazy
  },
}
