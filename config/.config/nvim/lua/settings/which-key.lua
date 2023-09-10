local wk = require("which-key")
wk.setup {
  -- triggers = {"<leader>", "<localleader>"},
  -- triggers_blacklist = {
  --   n = { "<leader>!" },
  -- },
}

wk.register({
  ["<leader>"] = {
    b = {
      name = "+buffer",
    },
    c = {
      name = "+comments",
    },
    f = {
      name = "+files",
      e = {
        name = "+environment",
      },
      t = {
        name = "+tree"
      },
    },
    g = {
      name = "+git/version-control",
      t = {
        name = "+toggles"
      },
    },
    t = {
      name = "+toogles",
    },
    w = {
      name = "+window",
    },
  },
  ["<localleader>"] = {
    g = {
      name = "+goto",
    },
  },
})
