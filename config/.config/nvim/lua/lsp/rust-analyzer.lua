local rust_tools = require("rust-tools")

local M = {}
M.setup = function(on_attach, capabilities)
  rust_tools.setup({
    tools = {
      autoSetHints = true,
      runnables = {
        use_telescope = true
      },
      inlay_hints = {
        show_parameter_hints = true,
        parameter_hints_prefix = "<- ",
        other_hints_prefix = "=> "
      }
    },
    server = {
      on_attach = on_attach,
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
            disabled = {"unresolved-proc-macro"},
          }
        }
      }
    }
  })
end

return M
