local lspconfig = require("lspconfig")

local M = {}
M.setup = function(on_attach, capabilities)
  -- Setup typescript.nvim once, globally
  local ts_ok, typescript = pcall(require, "typescript")
  if ts_ok then
    typescript.setup({
      disable_commands = false,
      debug = false,
      go_to_source_definition = {
        fallback = true,
      },
    })
  end

  lspconfig.ts_ls.setup({
      capabilities = capabilities,
      filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
      cmd = { "typescript-language-server", "--stdio" },
      root_dir = function(...)
        return require("lspconfig.util").root_pattern(".git")(...)
      end,
      on_attach = function(client, bufnr)
          -- Note: ts_ls doesn't provide built-in formatting
          -- You'll need to install prettier separately via Mason
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false

          -- Call the main on_attach
          on_attach(client, bufnr)
      end,
  })
end

return M
