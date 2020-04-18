--- C/C++/Objective C layer
-- @module l.c_cpp

local layer = {}

--- Returns plugins required for this layer
function layer.register_plugins()
end

--- Configures vim and plugins for this layer
function layer.init_config()
  local lsp = require("l.lsp")
  local nvim_lsp = require("nvim_lsp")

  lsp.register_server(nvim_lsp.ccls)
end

return layer
