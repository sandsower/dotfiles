local lspconfig = require('lspconfig')

local M = {}
M.setup = function(on_attach, capabilities)
  lspconfig.csharp_ls.setup({
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
end

return M
