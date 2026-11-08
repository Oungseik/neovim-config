return {
	{
		"olimorris/codecompanion.nvim",
		version = "v19.27.0",
		cmd = "CodeCompanionChat",
		keys = {
			{ "<leader>a", "<Nop>", desc = "AI" },
			{ "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle AI chat" },
			{ "<leader>an", "<cmd>CodeCompanionChat<cr>", desc = "New AI chat" },
			{ "<leader>as", "<cmd>CodeCompanionChat Add<cr>", desc = "Ask about selection", mode = "x" },
		},
		dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
		opts = {
			adapters = {
				acp = {
					opencode = function()
						local permissions =
							[[{"edit":"deny","bash":"ask","*_*":"ask","read":{"*.env":"ask","*.env.*":"ask","*.env.example":"allow"},"task":{"*":"deny","general":"allow","explore":"allow"}}]]
						local prompt = [[You are a programming mentor and code reviewer. The user writes their own code.
Investigate relevant project files, dependency versions, and official documentation when useful.
Explain reasoning, trade-offs, and findings with file paths or source links. Give actionable feedback and test ideas.
Prefer guiding questions and incremental hints; provide a complete example only when the user asks for one.
Do not modify project files. Ask before running commands.]]
						return require("codecompanion.adapters").extend("opencode", {
							env = {
								OPENCODE_ENABLE_EXA = function()
									return "1"
								end,
								OPENCODE_PERMISSION = function()
									return permissions
								end,
								OPENCODE_CONFIG_CONTENT = function()
									return ([[{"default_agent":"mentor","agent":{
										"mentor":{"mode":"primary","description":"Programming mentor and reviewer","prompt":%s,"permission":%s},
										"build":{"permission":%s},"plan":{"permission":%s},
										"general":{"permission":%s},"explore":{"permission":%s}
									}}]]):format(
										vim.json.encode(prompt),
										permissions,
										permissions,
										permissions,
										permissions,
										permissions
									)
								end,
							},
						})
					end,
				},
			},
			interactions = {
				chat = {
					adapter = "opencode",
					tools = { opts = { approval_mode = "ask" } },
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
	-- {
	-- 	"olimorris/codecompanion.nvim",
	-- 	version = "v19.23.0",
	-- 	event = "VeryLazy",
	-- 	keys = {
	-- 		{ "<leader>aa", "<cmd>CodeCompanionActions<cr>", desc = "AI actions", mode = { "n", "v" } },
	-- 		{ "<leader>an", "<cmd>CodeCompanionChat<cr>", desc = "New AI chat" },
	-- 		{ "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle AI chat", mode = { "n", "v" } },
	-- 		{ "<leader>ah", "<cmd>CodeCompanionHistory<cr>", desc = "AI chat history" },
	-- 	},
	-- 	opts = {
	-- 		adapters = {
	-- 			http = {
	-- 				opencode_go = function()
	-- 					return require("codecompanion.adapters").extend("openai", {
	-- 						name = "opencode_go",
	-- 						formatted_name = "OpenCode Go",
	-- 						url = "https://opencode.ai/zen/go/v1/chat/completions",
	-- 						env = {
	-- 							api_key = function()
	-- 								local key = vim.env.OPENCODE_GO_API_KEY
	-- 								if key and key ~= "" then return key end
	-- 								local auth = vim.json.decode(table.concat(vim.fn.readfile(vim.fn.expand("~/.local/share/opencode/auth.json")), "\n"))
	-- 								return auth["opencode-go"].key
	-- 							end,
	-- 						},
	-- 						headers = {
	-- 							["User-Agent"] = "CodeCompanion.nvim/19.23.0",
	-- 							["x-opencode-session"] = vim.fn.sha256(tostring(vim.uv.hrtime()) .. tostring(vim.uv.os_getpid())),
	-- 						},
	-- 						schema = {
	-- 							model = {
	-- 								default = "mimo-v2.6-pro",
	-- 								choices = {
	-- 									["mimo-v2.6-pro"] = {
	-- 										opts = { can_use_tools = true, has_vision = false },
	-- 									},
	-- 								},
	-- 							},
	-- 						},
	-- 					})
	-- 				end,
	-- 				zai = function()
	-- 					return require("codecompanion.adapters").extend("openai", {
	-- 						name = "zai",
	-- 						formatted_name = "Z.ai",
	-- 						url = "https://api.z.ai/api/coding/paas/v4/chat/completions",
	-- 						env = {
	-- 							api_key = [[cmd:if [ -z "$ZAI_API_KEY" ]; then . "$HOME/.env" >/dev/null 2>&1 || exit 1; fi; test -n "$ZAI_API_KEY" && printf "%s" "$ZAI_API_KEY"]],
	-- 						},
	-- 						schema = {
	-- 							model = {
	-- 								default = "glm-5.3",
	-- 								choices = {
	-- 									["glm-5.3"] = {
	-- 										meta = { context_window = 200000 },
	-- 										opts = { has_vision = false },
	-- 									},
	-- 								},
	-- 							},
	-- 							max_tokens = { default = 16384 },
	-- 						},
	-- 					})
	-- 				end,
	-- 				deepseek = function()
	-- 					local adapter = require("codecompanion.adapters").extend("deepseek", {
	-- 						env = {
	-- 							api_key = [[cmd:if [ -z "$DEEPSEEK_API_KEY" ]; then . "$HOME/.env" >/dev/null 2>&1 || exit 1; fi; test -n "$DEEPSEEK_API_KEY" && printf "%s" "$DEEPSEEK_API_KEY"]],
	-- 						},
	-- 						schema = {
	-- 							model = { default = "deepseek-flash" },
	-- 							max_tokens = { default = 16384 },
	-- 						},
	-- 					})
	-- 					-- The built-in adapter still lists the retired deepseek-v4-flash/chat/reasoner names
	-- 					adapter.schema.model.choices = {
	-- 						["deepseek-flash"] = {
	-- 							formatted_name = "DeepSeek V4.1 Flash",
	-- 							meta = { context_window = 1000000 },
	-- 							opts = { can_reason = true, can_use_tools = true },
	-- 						},
	-- 					}
	-- 					return adapter
	-- 				end,
	-- 			},
	-- 		},
	-- 		interactions = {
	-- 			chat = {
	-- 				adapter = "opencode_go",
	-- 				tools = { opts = { default_tools = { "agent" } } },
	-- 			},
	-- 			inline = { adapter = "opencode_go" },
	-- 			cmd = { adapter = "opencode_go" },
	-- 		},
	-- 		display = { chat = { window = { layout = "vertical", position = "right", width = 0.5 } } },
	-- 		extensions = {
	-- 			spinner = {},
	-- 			history = { enabled = true, opts = { auto_save = true, picker = "snacks" } },
	-- 			agentskills = {
	-- 				opts = {
	-- 					paths = { "~/.agents/skills", "~/.codex/skills" },
	-- 					disable_demo_skill = true,
	-- 				},
	-- 			},
	-- 		},
	-- 	},
	-- 	dependencies = {
	-- 		"franco-ruggeri/codecompanion-spinner.nvim",
	-- 		"cairijun/codecompanion-agentskills.nvim",
	-- 		"ravitemer/codecompanion-history.nvim",
	-- 		"folke/snacks.nvim",
	-- 		"nvim-lua/plenary.nvim",
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 		"saghen/blink.cmp",
	-- 		{
	-- 			"MeanderingProgrammer/render-markdown.nvim",
	-- 			opts = { file_types = { "markdown", "codecompanion" } },
	-- 			ft = { "markdown", "codecompanion" },
	-- 		},
	-- 	},
	-- },
}
