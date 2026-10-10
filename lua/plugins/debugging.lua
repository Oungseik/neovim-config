local layouts = require("debugging.layouts")
local configurations = require("debugging.configurations")
local adapters = require("debugging.adapters")

local function update_ui(action, reset)
	local dapui = require("dapui")
	local ui_buffers = {}
	for _, layout in ipairs(layouts) do
		for _, element in ipairs(layout.elements) do
			ui_buffers[dapui.elements[element.id].buffer()] = true
		end
	end
	-- Element buffers can also be displayed outside the managed layouts (e.g. the REPL).
	local ui_windows = {}
	for _, layout in ipairs(require("dapui.windows").layouts) do
		for _, win in pairs(layout.opened_wins) do
			ui_windows[win] = true
		end
	end

	local has_ui, editorless_windows = false, {}
	for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
		local has_editor, ui_window = false, nil
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
			if vim.api.nvim_win_get_config(win).relative == "" then
				if ui_windows[win] then
					has_ui = true
					ui_window = win
				elseif not ui_buffers[vim.api.nvim_win_get_buf(win)] then
					has_editor = true
				end
			end
		end
		if ui_window and not has_editor then
			editorless_windows[#editorless_windows + 1] = ui_window
		end
	end
	if action == "toggle" then
		action = has_ui and "close" or "open"
		reset = action == "open"
	end
	-- Preserve each UI-only tab before DAP UI closes its last pane.
	if action == "close" and #editorless_windows > 0 then
		local buffer
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.bo[buf].buflisted and not ui_buffers[buf] then
				buffer = buf
				break
			end
		end
		for _, win in ipairs(editorless_windows) do
			vim.api.nvim_win_call(win, function()
				vim.cmd(buffer and ("topleft sbuffer " .. buffer) or "topleft new")
			end)
		end
	end
	dapui[action]({ reset = reset })
end

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
			"mfussenegger/nvim-dap-python",
			{ "theHamsta/nvim-dap-virtual-text", opts = { virt_text_pos = "eol" } },
		},

		config = function()
			local dap = require("dap")

			dap.set_log_level("TRACE")

			dap.adapters = adapters
			dap.configurations = configurations

			require("dap-go").setup({})
			require("dap-python").setup("python3.14")

			-- breakpoint config
			-- dap.defaults.php.exception_breakpoints = { "Notice", "Warning", "Error", "Exception" }

			dap.listeners.before.attach.dapui_config = function()
				update_ui("open")
			end
			dap.listeners.before.launch.dapui_config = function()
				update_ui("open")
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				update_ui("close")
			end
			dap.listeners.before.event_exited.dapui_config = function()
				update_ui("close")
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
					update_ui("toggle")
				end,
				desc = "Toggle Debugger UI",
			},
			{
				"<leader>dR",
				function()
					update_ui("close")
					update_ui("open", true)
				end,
				desc = "Reset Debugger UI Layout",
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
