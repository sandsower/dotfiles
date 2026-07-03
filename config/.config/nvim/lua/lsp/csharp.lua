local M = {}

M.setup = function(on_attach, capabilities)
  vim.lsp.config('csharp_ls', {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      csharp_ls = {
        handlers = {
          ["textDocument/definition"] = require('csharpls_extended').handler,
        },
      },
    }
  })
  vim.lsp.enable('csharp_ls')
end

return M
