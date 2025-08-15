return {
	-- { "nvim-lua/plenary.nvim" },
	-- { "thenbe/neotest-playwright" },
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"marilari88/neotest-vitest",
			"arthur944/neotest-bun",
			"fredrikaverpil/neotest-golang",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("rustaceanvim.neotest"),
					require("neotest-golang"),
					require("neotest-vitest"),
					require("neotest-bun"),
					-- require("neotest-playwright").adapter({
					--   options = {
					--     persist_project_selection = true,
					--     enable_dynamic_test_discovery = true,
					--   },
					-- }),
				},
			})
		end,
		keys = {
			{
				"<leader>t",
				"<Nop>",
				desc = "+Tests",
				silent = true,
			},
			{
				"<leader>td",
				":lua require('neotest').run.run({strategy = 'dap'})<cr>",
				desc = "Debug Test",
				silent = true,
			},
			{
				"<leader>tf",
				":lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
				desc = "Run Test File",
				silent = true,
			},
			{ "<leader>tp", ":Neotest output-panel<cr>", desc = "Output Panel", silent = true },
			{ "<leader>tr", ":lua require('neotest').run.run()<cr>", desc = "Run Test", silent = true },
			{ "<leader>ts", ":lua require('neotest').run.stop()<cr>", desc = "Stop", silent = true },
			{
				"<leader>tS",
				":lua require('neotest').summary.toggle()<cr>",
				desc = "Summary",
				silent = true,
			},
		},
	},
}
