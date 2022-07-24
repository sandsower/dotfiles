local lspconfig = require("lspconfig")

local M = {}
M.setup = function(on_attach, capabilities)
  lspconfig.gopls.setup({
      on_attach = function(client, bufnr)

          on_attach(client, bufnr)
      end,
  })
end

return M
