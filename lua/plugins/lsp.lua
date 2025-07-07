return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"hedyhli/outline.nvim",
				lazy = true,
				cmd = { "Outline", "OutlineOpen" },
				keys = { -- Example mapping to toggle outline
					{ "<leader>lo", "<cmd>Outline<CR>", desc = "Toggle outline" },
				},
				opts = {
					symbols = {
						icons = {
							Function = { icon = "󰊕", hl = "Function" },
						},
					},
				},
			},
		},
		config = function()
			vim.lsp.enable("ts_ls")
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("prismals")
			vim.lsp.enable("jsonls")
			vim.lsp.enable("nil_ls")
			vim.lsp.enable("gopls")
			vim.lsp.enable("tombi")
      vim.lsp.enable("svelte")
		end,
	},

	{
		"mrcjkb/rustaceanvim",
		version = "^5",
		lazy = false, -- this plugin is already lazy
	},
	{
		"Bekaboo/dropbar.nvim",
		lazy = true,
		event = "BufNew",
		config = function()
			local dropbar_api = require("dropbar.api")
			vim.keymap.set("n", "<Leader>lp", dropbar_api.pick, { desc = "Pick symbols in winbar" })
		end,
	},
}
