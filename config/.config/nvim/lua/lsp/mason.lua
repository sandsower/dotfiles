local masonconfig = require("mason")

local M = {}
M.setup = function()
  local mason = masonconfig.setup()
  return mason
end

return M
