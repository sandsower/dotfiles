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

require('go').setup()
