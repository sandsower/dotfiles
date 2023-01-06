local lspconfig = require("lspconfig")

local M = {}
M.setup = function(on_attach, capabilities)
  lspconfig.tsserver.setup({
      capabilities = capabilities,
      on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
          local ts_utils = require("nvim-lsp-ts-utils")
          ts_utils.setup({})
          ts_utils.setup_client(client)
          on_attach(client, bufnr)
      end,
  })
end

return M
