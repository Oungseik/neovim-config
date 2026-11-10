return {
	"milanglacier/minuet-ai.nvim",
	main = "minuet",
	event = "InsertEnter",
	cmd = "Minuet",
	keys = {
		{
			"<M-Tab>",
			function()
				local action = require("minuet.virtualtext").action
				if action.is_visible() then
					action.accept_line()
				else
					action.dismiss()
					action.next()
				end
			end,
			mode = "i",
			desc = "Request AI completion or accept one line",
		},
		{
			"<M-y>",
			function()
				require("minuet.virtualtext").action.next()
			end,
			mode = "i",
			desc = "Request AI completion",
		},
		{
			"<M-l>",
			function()
				require("minuet.virtualtext").action.accept_line()
			end,
			mode = "i",
			desc = "Accept one AI completion line",
		},
	},
	opts = {
		provider = "codestral",
		n_completions = 1,
		context_window = 32000, -- Characters, not tokens.
		request_timeout = 30,
		presets = {
			codestral = { provider = "codestral" },
			granite = { provider = "openai_compatible" },
		},
		virtualtext = {
			auto_trigger_ft = {},
			show_on_completion_menu = true,
			keymap = {
				accept = "<M-a>",
				accept_n_lines = "<M-z>",
				prev = "<M-[>",
				next = "<M-]>",
				dismiss = "<M-e>",
			},
		},
		provider_options = {
			openai_compatible = {
				name = "OpenRouter",
				model = "ibm-granite/granite-4.2-8b",
				api_key = "OPENROUTER_API_KEY",
				end_point = "https://openrouter.ai/api/v1/chat/completions",
				optional = {
					max_tokens = 256,
					temperature = 0.2,
					reasoning = { enabled = false },
				},
			},
			codestral = {
				model = "codestral-latest",
				api_key = "MISTRAL_API_KEY",
				end_point = "https://api.mistral.ai/v1/fim/completions",
				stream = false,
				optional = {
					max_tokens = 256,
					temperature = 0.2,
				},
			},
		},
	},
}
