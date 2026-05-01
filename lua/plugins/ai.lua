return {
	-- opencode.nvim: AI coding assistant
	{
		"nickjvandyke/opencode.nvim",
		version = "*",
		init = function()
			local opencode_cmd = "opencode --port"
			---@type snacks.terminal.Opts
			local snacks_terminal_opts = {
				win = {
					position = "right",
					enter = false,
					on_win = function(win)
						require("opencode.terminal").setup(win.win)
					end,
				},
			}

			vim.g.opencode_opts = {
				server = {
					start = function()
						require("snacks.terminal").open(opencode_cmd, snacks_terminal_opts)
					end,
					stop = function()
						require("snacks.terminal").get(opencode_cmd, snacks_terminal_opts):close()
					end,
					toggle = function()
						require("snacks.terminal").toggle(opencode_cmd, snacks_terminal_opts)
					end,
				},
			}
		end,
		keys = {
			{ "<leader>a", "<Nop>", desc = "+AI", mode = "n" },
			{
				"<leader>aa",
				function()
					require("opencode").ask("@this: ", { submit = true })
				end,
				desc = "Ask opencode",
				mode = { "n", "x" },
			},
			{
				"<leader>ax",
				function()
					require("opencode").select()
				end,
				desc = "Select action",
				mode = { "n", "x" },
			},
			{
				"<leader>at",
				function()
					require("opencode").toggle()
				end,
				desc = "Toggle opencode",
				mode = { "n", "t" },
			},
			{
				"<leader>ao",
				function()
					return require("opencode").operator("@this ")
				end,
				desc = "Add range to opencode",
				expr = true,
				mode = { "n", "x" },
			},
			{
				"<leader>aoo",
				function()
					return require("opencode").operator("@this ") .. "_"
				end,
				desc = "Add line to opencode",
				expr = true,
				mode = "n",
			},
			{
				"<leader>a<Up>",
				function()
					require("opencode").command("session.half.page.up")
				end,
				desc = "Scroll opencode up",
			},
			{
				"<leader>a<Down>",
				function()
					require("opencode").command("session.half.page.down")
				end,
				desc = "Scroll opencode down",
			},
		},
	},

	-- Snacks.nvim picker integration: send picker items to opencode
	{
		"folke/snacks.nvim",
		optional = true,
		opts = {
			picker = {
				actions = {
					opencode_send = function(...)
						return require("opencode").snacks_picker_send(...)
					end,
				},
				win = {
					input = {
						keys = {
							["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
						},
					},
				},
			},
		},
	},
}
