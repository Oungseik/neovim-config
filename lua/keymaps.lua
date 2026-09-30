vim.api.nvim_set_keymap("n", "<leader>q", ":q<CR>", { noremap = true, silent = true, desc = "Quit" })
vim.api.nvim_set_keymap(
	"n",
	"<leader>U",
	":Lazy update<CR>",
	{ noremap = true, silent = true, desc = "Update Plugins" }
)

vim.api.nvim_set_keymap("n", "<C-s>", ":w<cr>", {})
vim.api.nvim_set_keymap("n", "<leader>w", ":w<CR>", { noremap = true, silent = true, desc = "Save" })

vim.api.nvim_set_keymap(
	"n",
	"<leader>h",
	":set invhlsearch<cr>",
	{ noremap = true, silent = true, desc = "Toggle Hightlight" }
)

-- swapping lines
vim.api.nvim_set_keymap("n", "<A-j>", ":m .+1<cr>==", {})
vim.api.nvim_set_keymap("n", "<A-k>", ":m .-2<cr>==", {})
vim.api.nvim_set_keymap("v", "<A-j>", ":m '>+1<cr>gv=gv", {})
vim.api.nvim_set_keymap("v", "<A-k>", ":m '<-2<cr>gv=gv", {})

-- select and indent
vim.api.nvim_set_keymap("v", ">", ">gv", {})
vim.api.nvim_set_keymap("v", "<", "<gv", {})

-- windows related keymaps
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", {})
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", {})
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", {})
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", {})

vim.api.nvim_set_keymap("i", "<C-l>", "<End>", {})

-- lsp
vim.api.nvim_set_keymap("n", "<leader>l", "<Nop>", { noremap = true, silent = true, desc = "+LSP" })
vim.keymap.set(
	"n",
	"<leader>lq",
	function()
		vim.fn.setqflist({}, " ", { title = "Diagnostics", items = vim.diagnostic.toqflist(vim.diagnostic.get(0)) })
		vim.cmd.cwindow()
	end,
	{ silent = true, desc = "Buffer Diagnostics Quickfix" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>la",
	":lua vim.lsp.buf.code_action()<cr>",
	{ noremap = true, silent = true, desc = "Action" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>lr",
	":lua vim.lsp.buf.rename()<cr>",
	{ noremap = true, silent = true, desc = "Rename" }
)
vim.api.nvim_set_keymap(
	"n",
	"gd",
	":lua vim.lsp.buf.definition()<cr>",
	{ noremap = true, silent = true, desc = "Go to Definition" }
)

vim.api.nvim_set_keymap(
	"n",
	"K",
	"<cmd>lua vim.lsp.buf.hover({ border = 'rounded' })<cr>",
	{ noremap = true, silent = true, desc = "Hover" }
)

-- Use Neovim's native commenting with the existing shortcut.
vim.keymap.set("n", "<leader>/", "gcc", { remap = true, silent = true, desc = "Toggle comment line" })
vim.keymap.set("x", "<leader>/", "gc", { remap = true, silent = true, desc = "Toggle comment" })
