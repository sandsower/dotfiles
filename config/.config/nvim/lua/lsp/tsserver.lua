local lspconfig = require("lspconfig")

local M = {}
M.setup = function(on_attach, capabilities)
  lspconfig.tsserver.setup({
      capabilities = capabilities,
      filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
      cmd = { "typescript-language-server", "--stdio" },
      root_dir = function(...)
        return require("lspconfig.util").root_pattern(".git")(...)
      end,
      on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
          ts = require("typescript")
          ts.setup(
          {
              disable_commands = false, -- prevent the plugin from creating Vim commands
              debug = false, -- enable debug logging for commands
              go_to_source_definition = {
                  fallback = true, -- fall back to standard LSP definition on failure
              },
              server = { -- pass options to lspconfig's setup method
                  on_attach = on_attach,
              },
          })
          on_attach(client, bufnr)
      end,
  })
end

return M
