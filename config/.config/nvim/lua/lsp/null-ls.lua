local null_ls = require("null-ls")

local M = {}
local gotest = require("go.null_ls").gotest()
local gotest_codeaction = require("go.null_ls").gotest_action()

local sources = {
  -- typescript
  null_ls.builtins.diagnostics.eslint_d,
  null_ls.builtins.code_actions.eslint_d,
  null_ls.builtins.formatting.prettierd,

  -- golang
  null_ls.builtins.diagnostics.golangci_lint,
  null_ls.builtins.diagnostics.revive,
  null_ls.builtins.formatting.golines.with({
    extra_args = {
      "--max-len=180",
      "--base-formatter=gofumpt",
    },
  })
}
table.insert(sources, gotest)
table.insert(sources, gotest_codeaction)

M.setup = function(on_attach)
  null_ls.setup({
    debug = true,
    sources = sources,
    on_attach = on_attach,
    debounce = 1000,
    default_timeout = 5000,
  })
end

return M
