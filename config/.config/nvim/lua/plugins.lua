local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Plugin Section
  --ColorSchemes
  {"morhetz/gruvbox", lazy = true},
  "mhartington/oceanic-next",
  "drewtempelmeyer/palenight.vim",

  --WhichKey for help
  "folke/which-key.nvim",

  --Autocompletion
  "neovim/nvim-lspconfig",
  "jose-elias-alvarez/null-ls.nvim",
  "jose-elias-alvarez/nvim-lsp-ts-utils",
  "nvim-lua/plenary.nvim",

  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/nvim-cmp",

  "williamboman/mason.nvim",

  -- "ray-x/lsp_signature.nvim"

  {
	  "nvim-treesitter/nvim-treesitter", 
	  build = ":TSUpdate" --We recommend updating the parsers on update
  },

  -- Terminal
  'voldikss/vim-floaterm',

  --Autopair/surround
  "tpope/vim-surround",
  "tpope/vim-commentary",
  "tpope/vim-repeat",
  "tpope/vim-abolish",

  --Git
  --"mhinz/vim-signify"
  "tpope/vim-fugitive",
  "lewis6991/gitsigns.nvim",

  --Snippets
  "hrsh7th/cmp-vsnip",
  "hrsh7th/vim-vsnip",

  --Debugging utils
  "ThePrimeagen/refactoring.nvim",

  --Fuzzy finder/movement
  {'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  "nvim-telescope/telescope.nvim",
  "phaazon/hop.nvim",

  --File Tree 
  "kyazdani42/nvim-web-devicons", --for file icons,
  {"kyazdani42/nvim-tree.lua", lazy = true},
  "jparise/vim-graphql",

  --Tests
  "vim-test/vim-test",
  {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/neotest-go",
    -- Your other test adapters here
  },
  config = function()
    -- get neotest namespace (api call creates or returns namespace)
    local neotest_ns = vim.api.nvim_create_namespace("neotest")
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          local message =
            diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
          return message
        end,
      },
    }, neotest_ns)
    require("neotest").setup({
      -- your neotest config here
      adapters = {
        require("neotest-go"),
      },
    })
  end,
},

  -- Copilot
  "github/copilot.vim",
  -- "zbirenbaum/copilot-cmp"
  -- {
  --   "zbirenbaum/copilot.lua",
  --   event = { "VimEnter" },
  --   config = function()
  --     vim.defer_fn(function()
  --       require "users.copilot"
  --     end, 100)
  --   end,
  -- }
  
  -- Visual improvements
  'yuttie/comfortable-motion.vim',

  --Statusline
  {
	  'glepnir/galaxyline.nvim',
	  branch = 'main',
	  -- some optional icons
	  dependencies = { 'kyazdani42/nvim-web-devicons', lazy = true },
	},

  -- Harpoon
  "ThePrimeagen/harpoon",

  -- Rust
  "simrat39/rust-tools.nvim",

  -- Scala
  {'scalameta/nvim-metals', dependencies = { "nvim-lua/plenary.nvim" }},

  -- Golang
  'mfussenegger/nvim-dap',
  'rcarriga/nvim-dap-ui',
  'theHamsta/nvim-dap-virtual-text',
  'ray-x/go.nvim',
  'ray-x/guihua.lua',

})
