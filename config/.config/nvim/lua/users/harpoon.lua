require('harpoon').setup({})

local wk = require("which-key")

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
wk.register({
  ["<leader>a"] = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "Harpoon: Add File" },
  ["<C-e>"] = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "Harpoon: Toggle Quick Menu" },
})

vim.keymap.set("n", "<leader><C-h>", function() ui.nav_file(1) end)
wk.register({
  ["<leader><C-h>"] = { "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", "Harpoon: Nav File 1" },
})
vim.keymap.set("n", "<leader><C-j>", function() ui.nav_file(2) end)
wk.register({
  ["<leader><C-j>"] = { "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", "Harpoon: Nav File 2" },
})
vim.keymap.set("n", "<leader><C-k>", function() ui.nav_file(3) end)
wk.register({
  ["<leader><C-k>"] = { "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", "Harpoon: Nav File 3" },
})
vim.keymap.set("n", "<leader><C-l>", function() ui.nav_file(4) end)
wk.register({
  ["<leader><C-l>"] = { "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", "Harpoon: Nav File 4" },
})
