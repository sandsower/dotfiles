local ih = require("inlay-hints")

local M = {}
M.setup = function(on_attach, capabilities)
  vim.lsp.config('gopls', {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      ih.on_attach(client, bufnr)
      on_attach(client, bufnr)
    end,
    settings = {
      gopls = {
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        }
      },
    },
  })
  vim.lsp.enable('gopls')
end

return M
