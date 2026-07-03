local M = {}

M.setup = function(on_attach, capabilities)
  vim.lsp.config('rust_analyzer', {
    on_attach = function(client, bufnr)
      if vim.lsp.inlay_hint then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
      on_attach(client, bufnr)
    end,
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        assist = {
          importGranularity = "module",
          importPrefix = "by_self"
        },
        cargo = {
          loadOutDirsFromCheck = true
        },
        procMacro = {
          enable = true
        },
        diagnostics = {
          disabled = { "unresolved-proc-macro" },
        }
      }
    }
  })
  vim.lsp.enable('rust_analyzer')
end

return M
