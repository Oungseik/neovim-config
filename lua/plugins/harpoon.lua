return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("harpoon"):setup()

		-- vim.api.set("n", "<leader>mm", function()
		--   harpoon.ui:toggle_quick_menu(harpoon:list())
		-- end, { noremap = true, silent = true, desc = "Harpoon Menu" })
	end,
	keys = {
		{
			"<leader>m",
			"<Nop>",
			desc = "+Marks (Harpoon)",
		},
		{
			"<leader>ma",
			":lua require('harpoon'):list():add()<cr>",
			desc = "Harpoon Add",
			silent = true,
		},
		{
			"<leader>mm",
			":lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<cr>",
			desc = "Menu",
			silent = true,
		},
	},
}
