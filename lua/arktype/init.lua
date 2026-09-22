local M = {}
local api = vim.api
local ns = api.nvim_create_namespace("arktype")
local languages = {
	typescript = "typescript",
	typescriptreact = "tsx",
	javascript = "javascript",
	javascriptreact = "javascript",
}
local calls = {}
for name in
	("type generic scope define match fn module and or case in extends ifExtends intersect merge exclude extract overlaps subsumes to satisfies"):gmatch(
		"%S+"
	)
do
	calls[name] = true
end
local queries = {}
local buffers = {}
local completion_timer

local function cancel_completion()
	if completion_timer then
		completion_timer:stop()
		completion_timer:close()
		completion_timer = nil
	end
end

local function definition(node, buf)
	local parent = node:parent()
	if parent and parent:type() == "pair" and parent:field("key")[1] == node then
		-- Only index signatures are type expressions; ordinary object keys are not.
		if not vim.treesitter.get_node_text(node, buf):match("^[\"'`]%[") then
			return false
		end
	end
	while parent do
		local kind = parent:type()
		if kind == "arrow_function" or kind == "function_expression" or kind == "function_declaration" then
			return false
		end
		if kind == "call_expression" then
			local fn = parent:field("function")[1]
			if not fn then
				return false
			end
			if fn:type() == "member_expression" then
				fn = fn:field("property")[1]
			end
			local name = fn and vim.treesitter.get_node_text(fn, buf) or ""
			-- ponytail: name-based recognition, like the VS Code grammar; use symbol resolution if aliases need support.
			return calls[name] or name:match("^[aA]rk[%a]*$") ~= nil
		end
		parent = parent:parent()
	end
	return false
end

local function highlight(node, buf)
	local text = vim.treesitter.get_node_text(node, buf)
	local row, col = node:range()
	local i, last = 2, #text - 1
	col = col + 1
	while i <= last do
		local start, start_col = i, col
		local char = text:sub(i, i)
		local group
		if char == "\n" then
			row, col, i = row + 1, 0, i + 1
		else
			if char:match("%s") then
				i = i + 1
			elseif char == '"' or char == "'" or char == "/" then
				group = char == "/" and "ArkTypeRegex" or "ArkTypeLiteral"
				i = i + 1
				local in_class = false
				while i <= last and text:sub(i, i) ~= "\n" do
					local c = text:sub(i, i)
					if c == "\\" then
						i = math.min(i + 2, last + 1)
					elseif c == char and not in_class then
						i = i + 1
						break
					else
						if char == "/" and c == "[" then
							in_class = true
						end
						if char == "/" and c == "]" then
							in_class = false
						end
						i = i + 1
					end
				end
			elseif char:match("%d") then
				group = "ArkTypeNumber"
				local _, stop = text:find("^%d+%.?%d*n?", i)
				i = stop + 1
			elseif char:match("[%a_$]") or char:byte() >= 128 then
				group = "ArkTypeType"
				local _, stop = text:find("^[%w_$.\128-\255]+", i)
				local token = text:sub(i, stop)
				if token == "true" or token == "false" then
					group = "ArkTypeBoolean"
				end
				i = stop + 1
			else
				group = "ArkTypeOperator"
				i = i + 1
			end
			col = col + i - start
			if group then
				api.nvim_buf_set_extmark(buf, ns, row, start_col, {
					end_col = col,
					hl_group = group,
					priority = 125,
				})
			end
		end
	end
end

local function refresh(buf)
	local lang = languages[vim.bo[buf].filetype]
	local state = buffers[buf]
	if not lang then
		api.nvim_buf_clear_namespace(buf, ns, 0, -1)
		if state then
			state.lang = nil
		end
		return
	end
	if not state then
		state = {}
		buffers[buf] = state
		api.nvim_buf_attach(buf, false, {
			on_lines = function(_, _, _, first, old_last, last)
				if state.first == nil then
					state.first, state.last = first, last
				elseif state.last == -1 then
					return
				elseif old_last == last then
					state.first, state.last = math.min(state.first, first), math.max(state.last, last)
				else
					-- ponytail: shifted coalesced ranges repaint fully; translate them if bulk edits become costly.
					state.first, state.last = 0, -1
				end
			end,
			on_reload = function()
				state.first, state.last = 0, -1
			end,
			on_detach = function()
				buffers[buf] = nil
			end,
		})
	end
	if state.lang ~= lang then
		state.lang, state.first, state.last = lang, 0, -1
	end
	if state.first == nil then
		return
	end
	local ok, parser = pcall(vim.treesitter.get_parser, buf, lang)
	if not ok or not parser then
		return
	end
	queries[lang] = queries[lang]
		or vim.treesitter.query.parse(lang, "(string) @definition (template_string) @definition")
	local first, last = state.first, state.last
	for _, tree in ipairs(parser:parse()) do
		local root = tree:root()
		if last ~= -1 then
			local count = api.nvim_buf_line_count(buf)
			first = math.min(first, count - 1)
			-- Expand to complete statements: changing a call name changes all its definitions.
			-- ponytail: one huge scope() still repaints as a unit; refine to call subtrees if profiling warrants it.
			local low, high = 0, root:child_count()
			while low < high do
				local mid = math.floor((low + high) / 2)
				local _, _, end_row = root:child(mid):range()
				if end_row < first then
					low = mid + 1
				else
					high = mid
				end
			end
			local child = root:child(low)
			while child do
				local start_row, _, end_row = child:range()
				if start_row > state.last then
					break
				end
				first, last = math.min(first, start_row), math.max(last, end_row)
				child = child:next_sibling()
			end
			last = last + 1 >= count and -1 or last + 1
		end
		api.nvim_buf_clear_namespace(buf, ns, first, last)
		for _, node in queries[lang]:iter_captures(root, buf, first, last) do
			local interpolated = false
			for child in node:iter_children() do
				if child:type() == "template_substitution" then
					interpolated = true
				end
			end
			if not interpolated and definition(node, buf) then
				highlight(node, buf)
			end
		end
	end
	state.first, state.last = nil, nil
end

local function enable_completion(buf)
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf, method = "textDocument/completion" })) do
		vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })
	end
end

--- Enable highlighting and native LSP completion (Neovim 0.11+).
--- Set completion=false when using nvim-cmp, blink.cmp, or another completion UI.
function M.setup(opts)
	opts = opts or {}
	assert(vim.fn.has("nvim-0.11") == 1, "ArkType requires Neovim 0.11 or newer")
	cancel_completion()
	local group = api.nvim_create_augroup("ArkType", { clear = true })
	local function colors()
		for suffix, link in pairs({
			Type = "Type",
			Number = "Number",
			Boolean = "Boolean",
			Operator = "Operator",
			Literal = "String",
			Regex = "String",
		}) do
			api.nvim_set_hl(0, "ArkType" .. suffix, { default = true, link = link })
		end
	end
	colors()
	api.nvim_create_autocmd("ColorScheme", { group = group, callback = colors })
	api.nvim_create_autocmd({ "FileType", "BufEnter", "TextChanged", "TextChangedI", "TextChangedP" }, {
		group = group,
		callback = function(event)
			refresh(event.buf)
		end,
	})
	if opts.completion ~= false then
		api.nvim_create_autocmd({ "LspAttach", "BufEnter" }, {
			group = group,
			callback = function(event)
				if languages[vim.bo[event.buf].filetype] then
					enable_completion(event.buf)
				end
			end,
		})
		api.nvim_create_autocmd({ "InsertLeave", "BufLeave", "TextChangedP", "FileType" }, {
			group = group,
			callback = cancel_completion,
		})
		api.nvim_create_autocmd("TextChangedI", {
			group = group,
			callback = function(event)
				cancel_completion()
				if not languages[vim.bo[event.buf].filetype] or vim.fn.pumvisible() == 1 then
					return
				end
				local buf = event.buf
				local tick = api.nvim_buf_get_changedtick(buf)
				local cursor = api.nvim_win_get_cursor(0)
				local timer
				timer = vim.defer_fn(function()
					if completion_timer ~= timer then
						return
					end
					completion_timer = nil
					if
						api.nvim_get_current_buf() ~= buf
						or vim.fn.mode() ~= "i"
						or not languages[vim.bo[buf].filetype]
						or api.nvim_buf_get_changedtick(buf) ~= tick
						or not vim.deep_equal(api.nvim_win_get_cursor(0), cursor)
						or vim.fn.pumvisible() == 1
					then
						return
					end
					-- Let the server handle incomplete strings and aliased imports after typing settles.
					vim.lsp.completion.get()
				end, 100)
				completion_timer = timer
			end,
		})
	end
	for _, buf in ipairs(api.nvim_list_bufs()) do
		if api.nvim_buf_is_loaded(buf) and languages[vim.bo[buf].filetype] then
			refresh(buf)
			if opts.completion ~= false then
				enable_completion(buf)
			end
		end
	end
end

return M
