--- dot net csharp
-- @module l.dot_net

local layer = {}

--- Returns plugins required for this layer
function layer.register_plugins()
end

--- Configures vim and plugins for this layer
function layer.init_config()
  local lsp = require("l.lsp")
  local build = require("l.build")
  local nvim_lsp = require("nvim_lsp")

  lsp.register_server(nvim_lsp.omnisharp)

end

return layer
