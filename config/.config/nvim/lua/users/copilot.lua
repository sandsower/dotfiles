local copilot = require'copilot' 

copilot.setup {
  cmp = {
    enabled = true,
    method = "getPanelCompletions",
  },
  panel = { -- no config options yet
    enabled = true,
  },
  ft_disable = { "markdown" },
}
