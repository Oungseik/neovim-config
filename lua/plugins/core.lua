return {
	-- { "EdenEast/nightfox.nvim", lazy = false, priority = 1000 },
	-- { "folke/tokyonight.nvim", lazy = false, priority = 1000 },
	-- { "olimorris/onedarkpro.nvim", lazy = false, priority = 1000 },
	-- { "rebelot/kanagawa.nvim", lazy = false, priority = 1000 },
	-- { "neanias/everforest-nvim", lazy = false, priority = 1000 },
	{ "catppuccin/nvim", lazy = false, name = "catppuccin", priority = 1000 },
	{ "kevinhwang91/nvim-bqf", opts = { auto_enable = false } },
	{
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {
			file_types = { "markdown", "Avante" },
			anti_conceal = { enabled = false },
		},
		ft = { "markdown", "Avante" },
	},
	{
		"nvim-treesitter/nvim-treesitter",
		name = "nvim-treesitter",
		branch = "main",
		lazy = false,
		priority = 1000,
		config = function()
			require("nvim-treesitter").setup({
				modules = {},
				auto_install = false,
				highlight = { enable = true },
				indent = { enable = true },
				sync_install = false,
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"rust",
					"markdown",
					"hurl",
					"lua",
					"typescript",
					"javascript",
					"typescriptreact",
					"javascriptreact",
					"svelte",
					"html",
					"css",
					"go",
				},
				callback = function()
					vim.treesitter.start()
				end,
			})
		end,
	},

	{ "folke/which-key.nvim", event = "VeryLazy" },

	{
		"numToStr/Comment.nvim",
		lazy = true,
		event = "BufNew",
		opts = { toggler = { line = "<leader>/" }, opleader = { line = "<leader>/" } },
	},

	{
		"kevinhwang91/nvim-ufo",
		event = "BufNew",
		dependencies = { "kevinhwang91/promise-async" },
		config = function()
			require("ufo").setup()
		end,
	},

	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		lazy = true,
		event = "BufNew",
		opts = {
			options = {
				separator_style = "slant",
				diagnostics = "nvim_lsp",
				modified_icon = " ",
				offsets = {
					{
						filetype = "NvimTree",
						text = "Explorer",
						highlight = "Directory",
						separator = true, -- use a "true" to enable the default, or set your own character
					},
					{
						filetype = "sagaoutline",
						text = "LSP Outline",
						separator = true, -- use a "true" to enable the default, or set your own character
					},
				},
			},
		},
		keys = {
			{ "<leader>b", "<Nop>", desc = "+Buffer" },
			{ "<leader>ba", ":BufferLineCloseOthers<cr>", desc = "Close All Buffers", silent = true },
			{ "<leader>bl", ":BufferLineCloseRight<cr>", desc = "Close Right Buffers", silent = true },
			{ "<leader>bh", ":BufferLineCloseLeft<cr>", desc = "Close Left Buffers", silent = true },
			{ "<S-h>", ":BufferLineCyclePrev<cr>", desc = "Prev Buffer", silent = true },
			{ "<S-l>", ":BufferLineCycleNext<cr>", desc = "Next Buffer", silent = true },
		},
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = true,
		event = "BufNew",
		opts = {
			options = {
				globalstatus = true,
				theme = "auto",

				disabled_filetypes = {
					statusline = { "startup", "alpha", "NvimTree", "neo-tree", "sagaoutline" },
					winbar = { "startup", "alpha", "NvimTree", "neo-tree", "sagaoutline" },
				},

				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},

			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					{
						function()
							local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
							if #buf_clients == 0 then
								return "LSP Inactive"
							end

							local buf_client_names = {}

							-- add client
							for _, client in pairs(buf_clients) do
								if client.name ~= "null-ls" and client.name ~= "copilot" then
									table.insert(buf_client_names, client.name)
								end
							end

							local unique_client_names = table.concat(buf_client_names, ", ")
							local language_servers = string.format("  %s", unique_client_names)

							return language_servers
						end,
					},
				},
				lualine_c = {
					{
						"diagnostics",
						source = "nvim_lsp",
						symbols = { error = " ", warn = " ", info = " ", hint = "󰝶 " },
					},
				},

				lualine_x = {
					{ "navic" },
					{
						function()
							local icon = " "
							local status = require("copilot.api").status.data
							return icon .. (status.message or " ")
						end,
						cond = function()
							local ok, clients = pcall(vim.lsp.get_clients, { name = "copilot", bufnr = 0 })
							return ok and #clients > 0
						end,
						color = { fg = "#a6da95" },
					},
				},
				lualine_y = {
					{ "diff", symbols = { added = " ", modified = " ", removed = " " } },
					{ "branch", icon = "" },
				},
				lualine_z = { "location" },
			},
		},
	},

	{
		"christoomey/vim-tmux-navigator",
		event = "BufEnter",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
			"TmuxNavigatorProcessList",
		},
		keys = { "<c-h>", "<c-j>", "<c-k>", "<c-l>" },
	},
}
