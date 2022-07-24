local null_ls = require("null-ls")

local M = {}

M.setup = function(on_attach)
  null_ls.setup({
    debug = true,
      sources = {
          -- typescript
          null_ls.builtins.diagnostics.eslint_d,
          null_ls.builtins.code_actions.eslint_d,
          null_ls.builtins.formatting.prettierd,

          -- golang
          null_ls.builtins.diagnostics.golangci_lint
     },
      on_attach = on_attach,
  })
end

return M
