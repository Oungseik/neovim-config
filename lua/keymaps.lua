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
vim.api.nvim_set_keymap("v", "<A-k>", ":m '<-1<cr>gv=gv", {})

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
vim.api.nvim_set_keymap(
	"n",
	"<leader>lq",
	":lua vim.diagnostic.setloclist()<cr>",
	{ noremap = true, silent = true, desc = "Quickfix" }
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
	{ noremap = true, silent = true, desc = "Rename" }
)



