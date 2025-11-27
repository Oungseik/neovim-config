return {
	{
		"stevearc/conform.nvim",
		lazy = true,
		event = "InsertEnter",
		opts = {
			notify_on_error = true,
			timeout_ms = 1000,

			formatters = {
				biome = {
					meta = {
						url = "https://github.com/biomejs/biome",
						description = "A toolchain for web projects, aimed to provide functionalities to maintain them.",
					},
					command = "biome",
					stdin = false,
					stdout = false,
					args = { "check", "--write", "$FILENAME" },
				},

				scheme = {
					meta = {
						url = "https://github.com/raviqqe/schemat",
						description = "Code formatter for Scheme, Lisp, and any S-expressions ",
					},
					command = "schemat",
					stdin = true,
					stdout = true,
				},
			},

			formatters_by_ft = {
				rust = { "rustfmt", lsp_format = "fallback", stop_after_first = true },
				toml = { lsp_format = "fallback", stop_after_first = true },
				lua = { "stylua" },
				python = { "ruff_format" },
				go = { "gofmt" },
				nix = { "nixfmt" },
				hurl = { "hurlfmt" },

				html = { "biome", "prettier", stop_after_first = true },
				css = { "biome", "prettier", stop_after_first = true },

				json = { "biome", "prettier", stop_after_first = true },
				jsonc = { "biome", "prettier", stop_after_first = true },
				javascript = { "biome", "prettier", stop_after_first = true },
				typescript = { "biome", "prettier", stop_after_first = true },
				javascriptreact = { "biome", "prettier", stop_after_first = true },
				typescriptreact = { "biome", "prettier", stop_after_first = true },

				astro = { "prettier", "biome", stop_after_first = true },
				svelte = { "prettier", "biome", stop_after_first = true, timeout_ms = 5000 },

				scheme = { "scheme" },
				sql = { "sleek" },
			},
		},
		keys = {
			{ "<leader>lf", ":lua require('conform').format()<cr>", desc = "Format", silent = true },
			-- { "<leader>lfj", ":%!jq . <cr>", desc = "Format json", silent = false, mode = "v" },
		},
	},
}
