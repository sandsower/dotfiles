local ih = require("inlay-hints")
local lspconfig = require("lspconfig")

local M = {}
M.setup = function(on_attach, capabilities)
  lspconfig.gopls.setup({
      on_attach = function(client, bufnr)
          ih.on_attach(client,bufnr)
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
end

return M
