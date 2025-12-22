return {
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false, -- Never set this value to "*"! Never!
		---@module 'avante'
		---@type avante.Config
		opts = {
			instructions_file = "AGENTS.md",

			provider = "deepseek",
			providers = {
				gemini = {
					endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
					api_key_name = "GEMINI_API_KEY",
					model = "gemini-2.5-flash-preview-09-2025",
					timeout = 30000, -- Timeout in milliseconds
					temperature = 0,
					max_tokens = 8192,
				},
				grok_code = {
					__inherited_from = "openai",
					endpoint = "https://openrouter.ai/api/v1",
					api_key_name = "OPENROUTER_API_KEY",
					model = "x-ai/grok-code-fast-1",
					-- model = "anthropic/claude-haiku-4.5",
				},

				grok = {
					__inherited_from = "openai",
					endpoint = "https://openrouter.ai/api/v1",
					api_key_name = "OPENROUTER_API_KEY",
					model = "x-ai/grok-4.1-fast:free",
				},

				deepseek = {
					__inherited_from = "openai",
					endpoint = "https://openrouter.ai/api/v1",
					api_key_name = "OPENROUTER_API_KEY",
					model = "deepseek/deepseek-v3.2",
				},
			},

			-- dual_boost = {
			-- 	enabled = false,
			-- 	first_provider = "openai",
			-- 	second_provider = "claude",
			-- 	prompt = "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
			-- 	timeout = 60000, -- Timeout in milliseconds
			-- },

			behaviour = {
				auto_suggestions = false, -- Experimental stage
				auto_set_highlight_group = true,
				auto_set_keymaps = true,
				auto_apply_diff_after_generation = false,
				support_paste_from_clipboard = false,
				minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
				enable_token_counting = true, -- Whether to enable token counting. Default to true.
				auto_add_current_file = true, -- Whether to automatically add the current file when opening a new chat. Default to true.
				auto_approve_tool_permissions = false, -- Default: auto-approve all tools (no prompts)
				-- Examples:
				-- auto_approve_tool_permissions = false,                -- Show permission prompts for all tools
				-- auto_approve_tool_permissions = {"bash", "str_replace"}, -- Auto-approve specific tools only
				---@type "popup" | "inline_buttons"
				confirmation_ui_style = "inline_buttons",
				--- Whether to automatically open files and navigate to lines when ACP agent makes edits
				---@type boolean
				-- acp_follow_agent_locations = true,
			},

			hints = { enabled = false },
			windows = { width = 50 },

			-- system_prompt = function()
			-- 	local hub = require("mcphub").get_hub_instance()
			-- 	return hub and hub:get_active_servers_prompt() or ""
			-- end,
			-- -- Using function prevents requiring mcphub before it's loaded
			-- custom_tools = function()
			-- 	return {
			-- 		require("mcphub.extensions.avante").mcp_tool(),
			-- 	}
			-- end,
		},
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = "make",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			-- {
			-- 	"ravitemer/mcphub.nvim",
			-- 	dependencies = {
			-- 		"nvim-lua/plenary.nvim",
			-- 	},
			-- 	build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
			-- 	config = function()
			-- 		require("mcphub").setup()
			-- 	end,
			-- 	keys = {
			-- 		{ "<leader>am", ":MCPHub<cr>", desc = "MCP Hub" },
			-- 	},
			-- },
		},
		keys = {
			{ "<leader>a", "<Nop>", desc = "+Avante" },
		},
	},
}
