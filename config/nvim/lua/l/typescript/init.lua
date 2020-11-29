--- Typescript layer
-- @module l.typescript
local plug = require("c.plug")

local layer = {}

--- Returns plugins required for this layer
function layer.register_plugins()
  -- plug.add_plugin("prettier/vim-prettier", { do = 'yarn install' })
end

--- Configures vim and plugins for this layer
function layer.init_config()
  local lsp = require("l.lsp")
  local nvim_lsp = require("lspconfig")

  lsp.register_server(nvim_lsp.tsserver)
end

return layer

