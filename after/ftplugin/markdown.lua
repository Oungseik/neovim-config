vim.o.wrap = true
vim.o.linebreak = true
vim.o.breakindent = true

vim.keymap.set("n", "<M-x>", function()
	local parser = vim.treesitter.get_parser(0, "markdown")
	if not parser then
		vim.notify("Markdown parser is required to toggle checkboxes", vim.log.levels.WARN)
		return
	end
	parser:parse()
	local node = vim.treesitter.get_node({ ignore_injections = true })
	while node and node:type() ~= "list_item" do
		if node:type() == "fenced_code_block" or node:type() == "indented_code_block" then
			return
		end
		node = node:parent()
	end
	if not node then
		return
	end
	for child in node:iter_children() do
		local kind = child:type()
		if kind == "task_list_marker_unchecked" or kind == "task_list_marker_checked" then
			local row, col, end_row, end_col = child:range()
			local marker = kind == "task_list_marker_unchecked" and "[x]" or "[ ]"
			vim.api.nvim_buf_set_text(0, row, col, end_row, end_col, { marker })
			return
		end
	end
	local marker = node:named_child(0)
	local _, _, row, col = marker:range()
	local text = vim.treesitter.get_node_text(marker, 0)
	local checkbox = text:match("%s$") and "[ ] " or " [ ] "
	vim.api.nvim_buf_set_text(0, row, col, row, col, { checkbox })
end, { buffer = true, desc = "Markdown Toggle Check" })

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "") .. "\n silent! nunmap <buffer> <M-x>"
