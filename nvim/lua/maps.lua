vim.g.mapleader = " "

local function map(mode, lhs, rhs)
	vim.keymap.set(mode, lhs, rhs, { silent = true })
end

-- Save
map("n", "<leader>w", "<CMD>update<CR>")

-- Quit
map("n", "<leader>q", "<CMD>q<CR>")

-- Exit insert mode
map("i", "jk", "<ESC>")

-- NeoTree
map("n", "<C-e>", "<CMD>Neotree toggle<CR>")

-- New Windows
map("n", "<leader>o", "<CMD>vsplit<CR>")
map("n", "<leader>p", "<CMD>split<CR>")

-- Window Navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-j>", "<C-w>j")

-- Resize Windows
map("n", "<C-Left>", "<C-w><")
map("n", "<C-Right>", "<C-w>>")
map("n", "<C-Up>", "<C-w>+")
map("n", "<C-Down>", "<C-w>-")

-- copy to system clipboard
map("v", "<leader>y", '"+y')

-- map({ "n", "v" }, "<C-a>", vim.lsp.buf.code_action, { desc = "Code Action" })
--
-- map('n', '<leader>re', vim.lsp.buf.rename, { desc = 'Rename Symbol' })
-- map('n', 'gd', vim.lsp.buf.definition, { desc = 'Goto Definition' })
-- map('n', 'gi', vim.lsp.buf.implementation, { desc = 'Goto Definition' })
-- map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action' })
-- map('n', 'K', vim.lsp.buf.hover, { desc = 'Hover Documentation' })
-- map('n', '<leader>ff', vim.lsp.buf.format, { desc = 'Format Code' })
