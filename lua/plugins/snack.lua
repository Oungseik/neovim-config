return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		bigfile = { enabled = true },
		dashboard = { enabled = true },
		explorer = { enabled = true },
		indent = { enabled = false },
		-- input = { enabled = true },
		picker = { enabled = true },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = false },
		statuscolumn = {
			enabled = true,
			left = { "sign" }, -- priority of signs on the left (high to low)
			right = { "git", "fold" }, -- priority of signs on the right (high to low)
			folds = {
				open = true, -- show open fold icons
				git_hl = false, -- use Git Signs hl for fold icons
			},
			git = {
				-- patterns to match Git signs
				patterns = { "GitSign", "MiniDiffSign" },
			},
			refresh = 50, -- refresh at most every 50ms
		},
		words = { enabled = true },
	},

	keys = {
		{
			"<leader>e",
			function()
				Snacks.explorer.open({
					auto_close = true,
					layout = { preset = "vertical", layout = { position = "float" } },
				})
			end,
			desc = "Explorer",
			mode = "n",
		},
		{
			"<leader>f",
			function()
				Snacks.picker.files()
			end,
			desc = "Search Files",
			mode = "n",
		},
		{
			"<leader>;",
			function()
				Snacks.dashboard()
			end,
			desc = "Dashboard",
			mode = "n",
		},

		{
			"<leader>s",
			"<Nop>",
			desc = "+Search",
			mode = "n",
		},
		{
			"<leader>sb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Search Buffers",
			mode = "n",
		},
		{
			"<leader>sc",
			function()
				Snacks.picker.commands()
			end,
			desc = "Search Commands",
			mode = "n",
		},
		{
			"<leader>sd",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "Search Diagnostics",
			mode = "n",
		},
		{
			"<leader>sf",
			function()
				Snacks.picker.files()
			end,
			desc = "Search Files",
			mode = "n",
		},
		{
			"<leader>sg",
			function()
				Snacks.picker.git_status()
			end,
			desc = "Search Git Status",
			mode = "n",
		},
		{
			"<leader>st",
			function()
				Snacks.picker.grep()
			end,
			desc = "Search text",
			mode = "n",
		},
	},
}
