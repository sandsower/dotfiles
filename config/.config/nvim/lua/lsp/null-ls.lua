local null_ls = require("null-ls")

local M = {}

local sources = {
  -- typescript
  null_ls.builtins.diagnostics.eslint_d,
  null_ls.builtins.code_actions.eslint_d,
  -- null_ls.builtins.formatting.prettierd,

  -- golang
  null_ls.builtins.diagnostics.golangci_lint,
  -- null_ls.builtins.diagnostics.revive,

   -- postgres
  null_ls.builtins.formatting.sqlfluff.with({
    extra_args = {"--dialect", "postgres"}
  }),
  null_ls.builtins.diagnostics.sqlfluff.with({
    extra_args = {"--dialect", "postgres"}
  })
}

M.setup = function(on_attach)
  null_ls.setup({
      debug = true,
    sources = sources,
    on_attach = on_attach,
    debounce = 1000,
    default_timeout = 5000,
  })
  require("mason-null-ls").setup({
---@diagnostic disable-next-line: assign-type-mismatch
    ensure_installed = nil,
    automatic_installation = true,
    automatic_setup = true,
  })
end

return M
