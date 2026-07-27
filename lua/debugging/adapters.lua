return {
	["rust-gdb"] = {
		type = "executable",
		command = "rust-gdb",
		args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
	},

	["pwa-node"] = {
		type = "server",
		host = "localhost",
		port = "${port}",
		executable = {
			command = "node",
			args = { vim.fn.expand("~/.local/share/debuggers/dapDebugServer.js"), "${port}" },
		},
	},

	php = {
		type = "executable",
		command = "node",
		args = { vim.fn.expand("~/.local/share/debuggers/phpDebug.js") },
	},
}
