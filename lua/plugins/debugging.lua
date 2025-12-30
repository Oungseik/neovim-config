local layouts = require("debugging.layouts")
local configurations = require("debugging.configurations")
local adapters = require("debugging.adapters")

return {
	{
		"rcarriga/nvim-dap-ui",
		lazy = true,
		opts = {
			layouts = layouts,
		},
	},
	{
		"leoluz/nvim-dap-go",
		lazy = true,
		ft = "go",
	},
	{
		"mfussenegger/nvim-dap",
		lazy = true,
		dependencies = {
			"nvim-neotest/nvim-nio",
		},

		config = function()
			local dap, dapui = require("dap"), require("dapui")

			if vim.fn.filereadable(".vscode/launch.json") then
				require("dap.ext.vscode").load_launchjs()
			end

			require("dap-go").setup({})
			dap.set_log_level("TRACE")

			dap.adapters = adapters
			dap.configurations = configurations

			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
		end,

		keys = {
			{ "<leader>d", "<Nop>", desc = "Debugger" },
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Continue",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
			},
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Breakpoint Condition",
			},
			{
				"<leader>du",
				function()
					require("dapui").toggle()
				end,
				desc = "Toggle Debugger UI",
			},
			{
				"<leader>dl",
				function()
					require("dapui").float_element("scopes", { enter = true })
				end,
				desc = "Locals Float Window",
			},
			{
				"<leader>de",
				function()
					require("dapui").float_element("watches", { enter = true })
				end,
				desc = "Expressions Float Window",
			},
			{
				"<leader>dL",
				function()
					require("dapui").float_element("breakpoints", { enter = true })
				end,
				desc = "Breakpoints Float Window",
			},
			{
				"<leader>ds",
				function()
					require("dapui").float_element("stacks", { enter = true })
				end,
				desc = "Stacks Float Window",
			},
		},
	},
}
