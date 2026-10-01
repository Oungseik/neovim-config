return {
	{ "rebelot/kanagawa.nvim", lazy = false },
	{
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {
			anti_conceal = { enabled = false },
		},
		ft = { "markdown" },
	},
	{
		"nvim-treesitter/nvim-treesitter",
		name = "nvim-treesitter",
		branch = "main",
		lazy = false,
		priority = 1000,
		config = function()
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
					"prisma",
					"php",
				},
				callback = function()
					vim.treesitter.start()
				end,
			})
		end,
	},

	{ "folke/which-key.nvim", event = "VeryLazy" },

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

				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},

			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					{
						function()
							-- Check if 'conform' is available
							local status, conform = pcall(require, "conform")
							if not status then
								return "Conform not installed"
							end

							local lsp_format = require("conform.lsp_format")

							-- Get formatters for the current buffer
							local formatters = conform.list_formatters_for_buffer()
							if formatters and #formatters > 0 then
								return "󰷈 " .. table.concat(formatters, " ")
							end

							-- Check if there's an LSP formatter
							local bufnr = vim.api.nvim_get_current_buf()
							local lsp_clients = lsp_format.get_format_clients({ bufnr = bufnr })

							if not vim.tbl_isempty(lsp_clients) then
								return "󰷈 LSP Formatter"
							end

							return ""
						end,
					},
					"lsp_status",
				},
				lualine_c = {
					{
						"diagnostics",
						source = "nvim_lsp",
						symbols = { error = " ", warn = " ", info = " ", hint = "󰝶 " },
					},
				},

				lualine_x = {},
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
	{
		"aaronik/treewalker.nvim",
		keys = {
			{ "<M-n>", ":Treewalker Down<cr>", desc = "Next block", silent = true },
			{ "<M-p>", ":Treewalker Up<cr>", desc = "Previous block", silent = true },
			{ "<M-i>", ":Treewalker Right<cr>", desc = "Inner block", silent = true },
			{ "<M-o>", ":Treewalker Left<cr>", desc = "Outer block", silent = true },
		},
	},
}
