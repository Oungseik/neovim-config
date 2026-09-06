return {
	{
		"olimorris/codecompanion.nvim",
		version = "v19.23.0",
		event = "VeryLazy",
		keys = {
			{ "<leader>aa", "<cmd>CodeCompanionActions<cr>", desc = "AI actions", mode = { "n", "v" } },
			{ "<leader>an", "<cmd>CodeCompanionChat<cr>", desc = "New AI chat" },
			{ "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle AI chat", mode = { "n", "v" } },
			{ "<leader>ah", "<cmd>CodeCompanionHistory<cr>", desc = "AI chat history" },
		},
		opts = {
			adapters = {
				http = {
					zai = function()
						return require("codecompanion.adapters").extend("openai", {
							name = "zai",
							formatted_name = "Z.ai",
							url = "https://api.z.ai/api/coding/paas/v4/chat/completions",
							env = {
								api_key = [[cmd:if [ -z "$ZAI_API_KEY" ]; then . "$HOME/.env" >/dev/null 2>&1 || exit 1; fi; test -n "$ZAI_API_KEY" && printf "%s" "$ZAI_API_KEY"]],
							},
							schema = {
								model = {
									default = "glm-5.3",
									choices = { ["glm-5.3"] = { meta = { context_window = 200000 }, opts = { has_vision = false } } },
								},
								max_tokens = { default = 16384 },
							},
						})
					end,
				},
			},
			interactions = {
				chat = { adapter = "zai" },
				inline = { adapter = "zai" },
				cmd = { adapter = "zai" },
			},
			display = { chat = { window = { layout = "vertical", position = "right", width = 0.5 } } },
			extensions = {
				spinner = {},
				history = { enabled = true, opts = { auto_save = true, picker = "snacks" } },
				agentskills = {
					opts = {
						paths = { "~/.agents/skills", "~/.codex/skills" },
						disable_demo_skill = true,
					},
				},
			},
		},
		dependencies = {
			"franco-ruggeri/codecompanion-spinner.nvim",
			"cairijun/codecompanion-agentskills.nvim",
			"ravitemer/codecompanion-history.nvim",
			"folke/snacks.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"saghen/blink.cmp",
			{
				"MeanderingProgrammer/render-markdown.nvim",
				opts = { file_types = { "markdown", "codecompanion" } },
				ft = { "markdown", "codecompanion" },
			},
		},
	},
}
