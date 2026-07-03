local M = {}

M.setup = function(on_attach, capabilities)
  vim.lsp.config('ts_ls', {
    capabilities = capabilities,
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
    cmd = { "typescript-language-server", "--stdio" },
    root_markers = { ".git" },
    on_attach = function(client, bufnr)
      -- Note: ts_ls doesn't provide built-in formatting
      -- You'll need to install prettier separately via Mason
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false

      -- Call the main on_attach
      on_attach(client, bufnr)
    end,
  })
  vim.lsp.enable('ts_ls')
end

return M
