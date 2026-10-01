---Pick the vitest runner for a test file. A `.vitest-runtime` file containing
---`bun`, searched from the test file upwards (nearest wins), runs vitest with
---bun. Everything else uses the project-local vitest under node, falling back
---to `vitest` on PATH.
---@param path string Path of the test file or directory being run
---@return string
local function vitest_command(path)
	-- `path` may be a file or a directory (neotest runs folder trees too), so
	-- search from it directly: vim.fs.find/root treat it as the first stop.
	local marker = vim.fs.find(".vitest-runtime", { path = path, upward = true, type = "file" })[1]
	if marker then
		local ok, lines = pcall(vim.fn.readfile, marker, "", 1)
		if ok and vim.trim(lines[1] or "") == "bun" then
			return "bun --bun vitest"
		end
	end

	-- Match neotest-vitest's default: nearest node_modules/.bin/vitest, then a
	-- hoisted one at the git root, otherwise `vitest` from PATH.
	local function node_bin(root)
		if not root then
			return nil
		end
		local bin = vim.fs.joinpath(root, "node_modules", ".bin", "vitest")
		return vim.uv.fs_stat(bin) and bin or nil
	end

	local bin = node_bin(vim.fs.root(path, { "node_modules" })) or node_bin(vim.fs.root(path, { ".git" }))
	if bin then
		return bin
	end

	return "vitest"
end

return {
	{
		"nvim-neotest/neotest",
		version = "*",
		dependencies = {
			"nvim-neotest/neotest-python",
			"nvim-neotest/nvim-nio",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"marilari88/neotest-vitest",
			{ "fredrikaverpil/neotest-golang", version = "*" },
			{ "thenbe/neotest-playwright" },
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("rustaceanvim.neotest"),
					require("neotest-golang")({ runner = "gotestsum" }),
					require("neotest-vitest")({ vitestCommand = vitest_command }),
					require("neotest-python"),

					require("neotest-playwright").adapter({
						options = {
							persist_project_selection = true,
							enable_dynamic_test_discovery = true,
						},
					}),
				},
			})
		end,
		keys = {
			{
				"<leader>t",
				"<Nop>",
				desc = "+Tests",
				silent = true,
			},
			-- { "<leader>ta", ":lua require('neotest').run.attach()<cr>", desc = "Attach Test", silent = true },
			{
				"<leader>td",
				":lua require('neotest').run.run({strategy = 'dap'})<cr>",
				desc = "Debug Test",
				silent = true,
			},
			{
				"<leader>tf",
				":lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
				desc = "Run Test File",
				silent = true,
			},
			{ "<leader>to", ":Neotest output-panel<cr>", desc = "Output Panel", silent = true },
			{
				"<leader>tO",
				":lua require('neotest').output_panel.clear()<cr>",
				desc = "Clear Output Panel",
				silent = true,
			},
			{ "<leader>tt", ":lua require('neotest').run.run()<cr>", desc = "Run Test", silent = true },
			{ "<leader>tS", ":lua require('neotest').run.stop()<cr>", desc = "Stop", silent = true },
			{
				"<leader>ts",
				":lua require('neotest').summary.toggle()<cr>",
				desc = "Summary",
				silent = true,
			},
		},
	},
}
