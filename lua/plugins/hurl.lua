return {
	"jellydn/hurl.nvim",
	lazy = true,
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	ft = "hurl",
	opts = {
		env_file = { ".env", "hurl.env" },
		debug = true,
	},
	keys = {
		-- Run API request
		{ "<leader>r", "<Nop>", desc = "+Request" },
		{ "<leader>rr", "<cmd>HurlRunnerAt<CR>", desc = "Run a request" },
		{ "<leader>ra", "<cmd>HurlRunner<CR>", desc = "Run All requests" },
		{ "<leader>rt", "<cmd>HurlRunnerToEntry<CR>", desc = "Run Api request to entry" },
		{ "<leader>re", "<cmd>HurlRunnerToEnd<CR>", desc = "Run Api request from current entry to end" },
		{ "<leader>rl", "<cmd>HurlShowLastResponse<CR>", desc = "Show last response" },
		-- Run Hurl request in visual mode
		{ "<leader>h", ":HurlRunner<CR>", desc = "Run selected requests", mode = "v" },
	},
}
