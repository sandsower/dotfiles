local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

packer.init {
	display = {
		open_fn = function()
			return require("packer.util").float { border = "rounded" }
		end,
	},
}

return packer.startup(function(use)
  use "wbthomason/packer.nvim" -- Have packer manage itself

  -- Plugin Section
  --ColorSchemes
  use "morhetz/gruvbox"
  use "mhartington/oceanic-next"
  use "drewtempelmeyer/palenight.vim"

  --WhichKey for help
  use "folke/which-key.nvim"

  --Autocompletion
  use "neovim/nvim-lspconfig"
  use "jose-elias-alvarez/null-ls.nvim"
  use "jose-elias-alvarez/nvim-lsp-ts-utils"
  use "nvim-lua/plenary.nvim"

  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-cmdline"
  use "hrsh7th/nvim-cmp"

  -- use "ray-x/lsp_signature.nvim"

  use {
	  "nvim-treesitter/nvim-treesitter", 
	  run = ":TSUpdate" --We recommend updating the parsers on update
  }

  --Autopair/surround
  use "tpope/vim-surround"
  use "tpope/vim-commentary"
  use "tpope/vim-repeat"
  use "tpope/vim-abolish"

  --Git
  --use "mhinz/vim-signify"
  use "tpope/vim-fugitive"
  use "lewis6991/gitsigns.nvim"


  --Snippets
  use "hrsh7th/cmp-vsnip"
  use "hrsh7th/vim-vsnip"

  --Debugging utils
  use "ThePrimeagen/refactoring.nvim"

  --Fuzzy finder/movement
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use "nvim-telescope/telescope.nvim"
  use "phaazon/hop.nvim"

  --File Tree 
  use "kyazdani42/nvim-web-devicons" --for file icons
  use "kyazdani42/nvim-tree.lua"
  use "jparise/vim-graphql"

  --Tests
  use "vim-test/vim-test"

  -- Copilot
  use "github/copilot.vim"
  -- use "zbirenbaum/copilot-cmp"
  -- use {
  --   "zbirenbaum/copilot.lua",
  --   event = { "VimEnter" },
  --   config = function()
  --     vim.defer_fn(function()
  --       require "users.copilot"
  --     end, 100)
  --   end,
  -- }
  
  --Statusline
  use({
	  'glepnir/galaxyline.nvim',
	  branch = 'main',
	  -- some optional icons
	  requires = { 'kyazdani42/nvim-web-devicons', opt = true },
	})

  -- Harpoon
  use "ThePrimeagen/harpoon"

end)
