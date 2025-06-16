return {
	{
		"stevearc/conform.nvim",
		lazy = true,
		event = "InsertEnter",
		opts = {
			notify_on_error = true,

			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				rust = { "rustfmt", lsp_format = "fallback", stop_after_first = true },
				go = { "gofmt" },
				nix = { "nixfmt" },

				javascript = { "prettier", "biome", "deno-fmt", stop_after_first = true },
				typescript = { "prettier", "biome", "deno-fmt", stop_after_first = true },
				javascriptreact = { "prettier", "biome", "deno-fmt", stop_after_first = true },
				typescriptreact = { "prettier", "biome", "deno-fmt", stop_after_first = true },
				json = { "prettier", "biome", "deno-fmt", stop_after_first = true },
				astro = { "prettier", "biome", "deno-fmt", stop_after_first = true },
				svelte = { "prettier", "biome", "deno-fmt", stop_after_first = true },
			},
		},
		keys = {
			{ "<leader>lf", ":lua require('conform').format()<cr>", desc = "Format", silent = true },
		},
	},
}
