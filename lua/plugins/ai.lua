return {
	{
		"olimorris/codecompanion.nvim",
		version = "*",
		cmd = { "CodeCompanion", "CodeCompanionChat" },
		keys = {
			{ "<leader>a", "<Nop>", desc = "AI" },
			{ "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle AI chat" },
			{ "<leader>an", "<cmd>CodeCompanionChat<cr>", desc = "New AI chat" },
			{ "<leader>as", "<cmd>CodeCompanionChat Add<cr>", desc = "Ask about selection", mode = "x" },
			{ "<leader>ae", ":CodeCompanion /edit<cr>", desc = "Edit selection with AI", mode = "x" },
		},
		dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
		opts = {
			prompt_library = {
				["Edit selection"] = {
					interaction = "inline",
					opts = {
						alias = "edit",
						adapter = { name = "mistral" },
						modes = { "v" },
						placement = "replace",
						user_prompt = true,
					},
					prompts = {},
				},
			},
			interactions = {
				chat = {
					adapter = "opencode",
					slash_commands = { resume = { keymaps = { modes = { n = "gh" } } } },
				},
			},
			display = {
				chat = {
					start_in_insert_mode = true,
					window = { layout = "vertical", position = "right", width = 0.5 },
				},
			},
		},
	},
	{
		dir = vim.fn.stdpath("config"),
		name = "ai_history",
		dependencies = { "olimorris/codecompanion.nvim" },
		keys = {
			{
				"<leader>ah",
				function()
					require("ai_history").open()
				end,
				desc = "AI chat history",
			},
		},
	},
}
