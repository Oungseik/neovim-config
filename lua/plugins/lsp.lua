return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"hedyhli/outline.nvim",
				lazy = true,
				cmd = { "Outline", "OutlineOpen" },
				keys = { -- Example mapping to toggle outline
					{ "<leader>lo", "<cmd>Outline<CR>", desc = "Toggle outline" },
				},
				opts = {
					outline_window = {
						auto_close = true,
					},
					symbols = {
						icons = {
							Function = { icon = "󰊕", hl = "Function" },
						},
					},
				},
			},
		},
		config = function()
			vim.lsp.config.lua_ls = {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = {
							globals = { "vim", "require" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
						},
						telemetry = { enable = false },
					},
				},
			}

			vim.lsp.config.intelephense = {
				settings = {
					intelephense = {
						stubs = {
							"*",
							"php",
							"bcmath",
							"bz2",
							"calendar",
							"Core",
							"curl",
							"zip",
							"zlib",
							"wordpress",
							"woocommerce",
							"acf-pro",
							"wordpress-globals",
							"wp-cli",
							"genesis",
							"polylang",
						},
						environment = {
							includePaths = {
								"/home/oung/Desktop/lampp/htdocs/bookogsend-store/wp-content/plugins/woocommerce",
								"/home/oung/.composer/vendor/php-stubs/",
							}, -- this line forces the composer path for the stubs in case inteliphense don't find it...
						},
						files = {
							maxSize = 5000000,
						},
					},
				},
			}

			-- vim.lsp.config.ts_ls = {
			-- 	filetypes = { "javascript", "javascriptreact" },
			-- }
			--
			-- vim.lsp.config.tsgo = {
			-- 	filetypes = { "typescript", "typescriptreact" },
			-- }

			vim.lsp.enable({
				-- "hls",
				"lua_ls",
				"svelte",
				"cssls",
				"tsgo",
				"prismals",
				"jsonls",
				-- "nil_ls",
        "nixd"
				"gopls",
				"tombi",
				"ruff",
				"ty",
				"markdown_oxide",
				"yamlls",
				"intelephense",
			})
		end,
	},
	{
		"mrcjkb/haskell-tools.nvim",
		version = "^9",
		lazy = false,
	},
	{
		"mrcjkb/rustaceanvim",
		version = "9.0.1",
		lazy = false, -- this plugin is already lazy
	},
	{
		"Bekaboo/dropbar.nvim",
		lazy = true,
		event = "BufNew",
		config = function()
			local dropbar_api = require("dropbar.api")
			vim.keymap.set("n", "<Leader>lp", dropbar_api.pick, { desc = "Pick symbols in winbar" })
		end,
	},
}
