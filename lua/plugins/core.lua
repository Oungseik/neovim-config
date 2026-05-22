return {
	-- { "EdenEast/nightfox.nvim", lazy = false, priority = 1000 },
	-- { "olimorris/onedarkpro.nvim", lazy = false, priority = 1000 },
	{ "rebelot/kanagawa.nvim", lazy = false },
	-- { "neanias/everforest-nvim", lazy = false },
	-- {
	-- 	"folke/tokyonight.nvim",
	--    lazy = false,
	--    priority = 1000,
	-- 	-- opts = {
	-- 	-- transparent = true,
	-- 	-- styles = {
	-- 	-- 	sidebars = "transparent",
	-- 	-- 	floats = "transparent",
	-- 	-- },
	-- 	-- },
	-- },
	-- {
	-- 	"catppuccin/nvim",
	-- 	lazy = false,
	-- 	name = "catppuccin",
	-- 	priority = 1000,
	-- 	-- opts = {
	-- 	-- 	transparent_background = true,
	-- 	-- },
	-- },
	{ "kevinhwang91/nvim-bqf", opts = { auto_enable = true } },
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
			require("ufo").setup({
				provider_selector = function(bufnr, filetype, buftype)
					if filetype == "cabal" then
						return { "indent", "treesitter" }
					end
					return { "lsp", "indent" }
				end,
			})
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
							-- Check if 'conform' is available
							local status, conform = pcall(require, "conform")
							if not status then
								return "Conform not installed"
							end

							local lsp_format = require("conform.lsp_format")

							-- Get formatters for the current buffer
							local formatters = conform.list_formatters_for_buffer()
							if formatters and #formatters > 0 then
								local formatterNames = {}

								for _, formatter in ipairs(formatters) do
									table.insert(formatterNames, formatter)
								end

								return "󰷈 " .. table.concat(formatterNames, " ")
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
