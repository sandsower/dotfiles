require "plugins"

require "lsp"
require "users.keymaps"
require "users.nvim-tree"
-- require "users.nvim-treesitter"
require "users.cmp"
require "users.refactoring"
require "users.galaxyline"
require "users.options"
require "users.colorscheme"

-- require "users.copilot"
require "which-key".setup() 
require "hop".setup()
-- require "telescope".load_extension('fzf')
require "refactoring".setup({})

