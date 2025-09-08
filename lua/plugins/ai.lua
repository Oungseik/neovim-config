return {
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false, -- Never set this value to "*"! Never!
		---@module 'avante'
		---@type avante.Config
		opts = {
			provider = "copilot",
			auto_suggestions_provider = "copilot",
			providers = {
				copilot = { model = "gpt-4.1-2025-04-14" },
				gemini = {
					endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
					api_key_name = "GEMINI_API_KEY",
					model = "gemini-2.5-flash-preview-05-20",
					timeout = 30000, -- Timeout in milliseconds
					temperature = 0,
					max_tokens = 8192,
				},
			},
			hints = { enabled = false },
			windows = { width = 40 },
			system_prompt = function()
				local hub = require("mcphub").get_hub_instance()
				return hub and hub:get_active_servers_prompt() or ""
			end,
			-- Using function prevents requiring mcphub before it's loaded
			custom_tools = function()
				return {
					require("mcphub.extensions.avante").mcp_tool(),
				}
			end,
		},
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = "make",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"zbirenbaum/copilot.lua", -- for providers='copilot'
			{
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
			{
				"ravitemer/mcphub.nvim",
				dependencies = {
					"nvim-lua/plenary.nvim",
				},
				build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
				config = function()
					require("mcphub").setup()
				end,
				keys = {
					{ "<leader>am", ":MCPHub<cr>", desc = "MCP Hub" },
				},
			},
			{
				"saghen/blink.compat",
				lazy = true,
				opts = {},
				config = function()
					-- monkeypatch cmp.ConfirmBehavior for Avante
					require("cmp").ConfirmBehavior = {
						Insert = "insert",
						Replace = "replace",
					}
				end,
			},
			{
				"saghen/blink.cmp",
				lazy = true,
				dependencies = {
					"Kaiser-Yang/blink-cmp-avante",
				},
				opts = {
					sources = {
						default = { "avante", "avante_commands", "avante_mentions", "avante_files" },
						providers = {
							avante = {
								module = "blink-cmp-avante",
								name = "Avante",
								opts = {},
							},
							avante_commands = {
								name = "avante_commands",
								module = "blink.compat.source",
								score_offset = 90, -- show at a higher priority than lsp
								opts = {},
							},
							avante_files = {
								name = "avante_commands",
								module = "blink.compat.source",
								score_offset = 100, -- show at a higher priority than lsp
								opts = {},
							},
							avante_mentions = {
								name = "avante_mentions",
								module = "blink.compat.source",
								score_offset = 1000, -- show at a higher priority than lsp
								opts = {},
							},
						},
					},
				},
			},
		},
		keys = {
			{ "<leader>a", "<Nop>", desc = "+Avante" },
		},
	},
}
