M = {}
local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = ","
local wk = require("which-key")


wk.register({
  ["<leader>a"] = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "Harpoon: Add File" },
  ["<C-e>"] = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "Harpoon: Toggle Quick Menu" },
})

-- Telescope
keymap("n", "<leader>ff", "<cmd>Telescope git_files<cr>", opts)
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
keymap("n", "<leader>fs", "<cmd>Telescope grep_string<cr>", opts)
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)

-- Neovim LSP pickers
keymap("n", "<leader>fa", "<cmd>Telescope lsp_code_actions<cr>", opts)
keymap("n", "<leader>fr", "<cmd>Telescope lsp_references<cr>", opts)
keymap("n", "<leader>fd", "<cmd>Telescope lsp_definitions<cr>", opts)
keymap("n", "<leader>fi", "<cmd>Telescope lsp_implementations<cr>", opts)

-- Git pickers
keymap("n", "<leader>gs", "<cmd>Telescope git_status<cr>", opts)
keymap("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", opts)
keymap("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", opts)
keymap("n", "<leader>gC", "<cmd>Telescope git_bcommits<cr>", opts)

-- Navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Hop
keymap("n", "<leader>h", "<cmd>HopWord<CR>", opts)
keymap("n", "<leader>l", "<cmd>HopLine<CR>", opts)
keymap("v", "<leader>h", "<cmd>HopwWord<CR>", opts)
keymap("v", "<leader>l", "<cmd>HopLine<CR>", opts)

-- Git
-- Using lazygit directly for the rest
keymap("n", "<leader>b", ":Git blame<CR>", opts)

-- NeoTest
keymap("n", "<leader>tt", "<cmd>lua require('neotest').run.run()<CR>", opts)
keymap("n", "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>", opts)
keymap("n", "<leader>to", "<cmd>lua require('neotest').summary.toggle()<CR>", opts)
wk.register({
  ["<leader>tt"] = { "<cmd>lua require('neotest').run.run()<cr>", "Run nearest tests" },
  ["<leader>tf"] = { "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>", "Run the current test file" },
  ["<leader>to"] = { "<cmd>lua require('neotest').summary.toggle()<CR>", "Toggle Neotest summary" },
})


-- Clipboard
keymap("n", "<leader>y", "\"*y", opts)
keymap("v", "<leader>y", "\"*y", opts)
keymap("n", "<leader>Y", "\"+y", opts)
keymap("v", "<leader>Y", "\"+y", opts)
keymap("n", "<leader>P", "\"+y", opts)
keymap("x", "<leader>p", "\"_dP", opts)

-- Nvim-Tree
keymap("n", "<C-n>", ":NvimTreeToggle<CR>", opts)
keymap("n", "<leader>r", ":NvimTreeRefresh<CR>", opts)

-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in visual mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

return M
