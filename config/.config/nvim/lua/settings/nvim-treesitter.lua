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

    -- list of language that will be disabled
    -- disable = { "c", "rust" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
})

-- Ensure Treesitter attaches to all buffers
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter", "BufReadPost", "BufRead"}, {
  pattern = "*",
  callback = function(args)
    local buf = args.buf
    local ft = vim.bo[buf].filetype
    local buftype = vim.bo[buf].buftype
    local bufname = vim.api.nvim_buf_get_name(buf)

    -- Skip special buffers
    if ft == "" or ft == "help" or ft == "NvimTree" or buftype ~= "" then
      return
    end

    -- Ensure buffer is properly set for existing files
    if bufname ~= "" and vim.fn.filereadable(bufname) == 1 then
      vim.bo[buf].buftype = ""
    end

    -- Skip if already attached
    if vim.treesitter.highlighter.active[buf] then
      return
    end

    -- Get the language name that treesitter uses (handles filetype -> lang mapping)
    local lang = vim.treesitter.language.get_lang(ft)
    if not lang then
      lang = ft
    end

    -- Check if parser is available and start treesitter
    local has_parser = pcall(vim.treesitter.get_parser, buf, lang)
    if has_parser then
      pcall(vim.treesitter.start, buf, lang)
    end
  end,
})
