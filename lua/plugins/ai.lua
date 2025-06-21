return {
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false, -- Never set this value to "*"! Never!
    config = function()
      require("avante").setup({
        provider = "copilot",
        providers = {
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

        -- system_prompt as function ensures LLM always has latest MCP server state
        -- This is evaluated for every message, even in existing chats
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
      })
    end,
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = "make",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"echasnovski/mini.pick", -- for file_selector provider mini.pick
			"zbirenbaum/copilot.lua", -- for providers='copilot'
      -- "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
			{
				-- Make sure to set this up properly if you have lazy=true
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
			},
		},
		keys = {
			{ "<leader>a", "<Nop>", desc = "+Avante" },
		},
	},
}
