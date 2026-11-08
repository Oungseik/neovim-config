local M = {}

function M.open()
	local context = require("codecompanion.utils.context").get()
	local cwd = vim.fn.getcwd()
	local connection = require("codecompanion.acp").new({
		adapter = require("codecompanion.adapters").resolve("opencode"),
	})
	local async = require("codecompanion.utils.async")
	local utils = require("codecompanion.utils")

	local function stop(message)
		pcall(connection.disconnect, connection)
		if message then
			utils.notify(message, vim.log.levels.WARN)
		end
	end

	async.sync(function()
		if not connection:connect_and_authenticate() then
			return stop("Could not connect to OpenCode")
		end
		if not connection:can_list_sessions() or not connection:can_load_session() then
			return stop("This OpenCode version does not support resuming sessions")
		end
		local sessions = connection:session_list()
		if #sessions == 0 then
			return stop("No previous OpenCode sessions found")
		end

		vim.ui.select(sessions, {
			prompt = "Resume OpenCode session",
			format_item = function(session)
				return session.title or session.sessionId
			end,
		}, function(selected)
			if not selected then
				return stop()
			end
			if not connection:is_ready() then
				return stop("OpenCode disconnected; reopen history to try again")
			end
			async.sync(function()
				local updates = {}
				connection.session_id = selected.sessionId
				connection._loading_session = true
				connection._on_session_update = function(update)
					updates[#updates + 1] = update
				end
				local servers = connection.adapter_modified.defaults.mcpServers
				if servers == "inherit_from_config" and require("codecompanion.config").mcp.opts.acp_enabled then
					servers = require("codecompanion.mcp").transform_to_acp()
				end
				-- The built-in load_session creates a new session when loading fails.
				local result = connection:send_rpc_request("session/load", {
					sessionId = selected.sessionId,
					cwd = cwd,
					mcpServers = servers,
				})
				connection._loading_session, connection._on_session_update = nil, nil
				if not result or not connection:is_connected() then
					return stop("Could not resume the selected OpenCode session")
				end
				if result.configOptions then
					connection:_apply_config_options(result.configOptions)
				end
				-- A disconnected history chat must never create a replacement session.
				connection.ensure_session = function(self)
					return self.session_id == selected.sessionId
				end

				local chat = require("codecompanion").chat({
					context = context,
					params = { adapter = "opencode" },
					callbacks = {
						on_created = function(created)
							created.acp_connection = connection
							connection.chat = created
						end,
					},
				})
				if not chat then
					return stop("Could not open the resumed chat")
				end
				require("codecompanion.interactions.chat.acp.commands").link_buffer_to_session(
					chat.bufnr,
					selected.sessionId
				)
				require("codecompanion.interactions.shared.watch").enable()
				utils.fire("ACPConnected", { bufnr = chat.bufnr })
				require("codecompanion.interactions.chat.acp.render").restore_session(chat, updates)
				if selected.title then
					chat:set_title(selected.title)
				end
				utils.fire("ACPChatRestored", {
					bufnr = chat.bufnr,
					id = chat.id,
					session_id = selected.sessionId,
					title = chat.title,
				})
			end)()
		end)
	end)()
end

return M
