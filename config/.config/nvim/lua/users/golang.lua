local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
   require('go.format').goimport()
  end,
  group = format_sync_grp,
})

vim.g["go_highlight_operators"] = 1
vim.g["go_highlight_functions"] = 1
vim.g["go_highlight_function_parameters"] = 1
vim.g["go_highlight_function_calls"] = 1
vim.g["go_highlight_types"] = 1
vim.g["go_highlight_fields"] = 1

require('go').setup({
  goimport = "gopls", -- if set to 'gopls', it will use golsp's goimports instead of goimports
  gofmt = "gopls", -- if set to 'gopls', it will use golsp's gofmt instead of gofmt
  max_line_len = 120,
  tag_transform = false,
  test_dir = "",
  comment_placeholder = "   ",
  lsp_cfg = true, -- false: if you don't want to setup lspconfig
  lsp_gofumpt = true, -- set to true if you want to use gofumpt instead of gofmt
  lsp_on_attach = false, -- false: if you want to define your own on_attach function
  lsp_diag_signs = true, -- false: to not define signs for diagnostics
  lsp_document_formatting = false, -- set to true if you want to use gopls for formatting, using null-ls otherwise
  lsp_settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
})

