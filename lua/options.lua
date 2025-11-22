vim.o.foldmethod = "manual"
vim.wo.number = true
vim.o.cursorline = true
-- vim.o.signcolumn = "yes"
vim.o.ignorecase = true
vim.o.relativenumber = false
vim.o.showmode = false
vim.o.breakindent = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.showtabline = 2
vim.o.smartindent = true
vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.wrap = false
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.scrolloff = 3

vim.o.foldenable = true
vim.o.foldcolumn = "0"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.winborder = "rounded"

vim.opt.clipboard = "unnamedplus"
vim.cmd.colorscheme("catppuccin-macchiato")

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.HINT] = "󰌵",
			[vim.diagnostic.severity.INFO] = "",
		},
	},
})

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DapBreakpointCondition" })
vim.fn.sign_define("DapBreakpointRejected", { text = "◆", texthl = "DapBreakpointRejected" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped" })

-- auto-reload files when modified externally
-- https://unix.stackexchange.com/a/383044
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	command = "if mode() != 'c' | checktime | endif",
	pattern = { "*" },
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "json",
	callback = function()
		vim.bo.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
})

vim.filetype.add({
	extension = {
		mdx = "markdown",
	},
})

local function qf_remove_at_cursor()
	local currline = vim.fn.line(".")
	local qf_list = vim.fn.getqflist()

	-- Filter out the current line
	local new_list = {}
	for i, item in ipairs(qf_list) do
		if i ~= currline then
			table.insert(new_list, item)
		end
	end

	-- Replace quickfix list
	vim.fn.setqflist(new_list, "r")

	-- Move cursor back to same (or nearest) line safely
	local new_line = math.min(currline, #new_list)
	vim.cmd.normal({ args = { tostring(new_line) .. "G" }, bang = false })
end

vim.api.nvim_create_augroup("quickfix", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = "quickfix",
	pattern = "qf",
	callback = function()
		vim.keymap.set("n", "x", qf_remove_at_cursor, { buffer = true, silent = true })
	end,
})
