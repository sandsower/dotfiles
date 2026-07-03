local treesitter_start = vim.treesitter.start
vim.treesitter.start = function(bufnr, lang)
  bufnr = bufnr or 0
  lang = lang or vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)

  if lang == "markdown" or lang == "markdown_inline" then
    return
  end

  return treesitter_start(bufnr, lang)
end

---@diagnostic disable-next-line: missing-fields
require('nvim-treesitter.configs').setup({
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = "all",

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,
  auto_install = false,

  -- List of parsers to ignore installing (ipkg has broken download)
  ignore_install = { "ipkg" },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- Markdown currently trips Neovim 0.12's injected parser path on some files.
    -- Keep normal syntax highlighting for markdown and Tree-sitter elsewhere.
    disable = { "markdown", "markdown_inline" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
})

require('treesitter-context').setup({
  on_attach = function(bufnr)
    return vim.bo[bufnr].filetype ~= "markdown"
  end,
})

vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
  pattern = "markdown",
  callback = function(args)
    pcall(vim.treesitter.stop, args.buf)
  end,
})
