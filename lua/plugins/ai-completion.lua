return {
	"milanglacier/minuet-ai.nvim",
	main = "minuet",
	event = "InsertEnter",
	cmd = "Minuet",
	keys = {
		{
			"<M-y>",
			function()
				require("minuet.virtualtext").action.next()
			end,
			mode = "i",
			desc = "Request AI completion / next suggestion",
		},
	},
	opts = {
		provider = "codestral",
		n_completions = 1,
		context_window = 8000, -- Characters, not tokens.
		request_timeout = 5,
		presets = {
			codestral = { provider = "codestral" },
			granite = { provider = "openai_compatible" },
		},
		virtualtext = {
			auto_trigger_ft = {},
			show_on_completion_menu = true,
			keymap = {
				accept = "<A-A>",
				accept_line = "<Tab>",
				accept_n_lines = "<A-z>",
				prev = "<A-[>",
				next = "<A-]>",
				dismiss = "<A-e>",
			},
		},
		provider_options = {
			openai_compatible = {
				name = "OpenRouter",
				model = "ibm-granite/granite-4.2-8b",
				api_key = "OPENROUTER_API_KEY",
				end_point = "https://openrouter.ai/api/v1/chat/completions",
				optional = {
					max_tokens = 128,
					temperature = 0.2,
					reasoning = { enabled = false },
				},
			},
			codestral = {
				model = "codestral-latest",
				api_key = "MISTRAL_API_KEY",
				end_point = "https://api.mistral.ai/v1/fim/completions",
				optional = {
					max_tokens = 128,
					temperature = 0.2,
				},
			},
		},
	},
}
