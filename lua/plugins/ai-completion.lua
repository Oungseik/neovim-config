return {
	"milanglacier/minuet-ai.nvim",
	main = "minuet",
	event = "InsertEnter",
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
		virtualtext = {
			auto_trigger_ft = {},
			keymap = {
				accept = "<A-A>",
				accept_line = "<A-a>",
				accept_n_lines = "<A-z>",
				prev = "<A-[>",
				next = "<A-]>",
				dismiss = "<A-e>",
			},
		},
		provider_options = {
			codestral = {
				model = "codestral-2508",
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
