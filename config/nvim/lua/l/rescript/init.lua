--- Rescript layer
-- @module l.rescript
local plug = require("c.plug")

local layer = {}

--- Returns plugins required for this layer
function layer.register_plugins()
  plug.add_plugin("rescript-lang/vim-rescript")
end

--- Configures vim and plugins for this layer
function layer.init_config()
  -- local lsp = require("l.lsp")
  -- local nvim_lsp = require("lspconfig")
  -- local configs = require("lspconfig/configs")
  -- local rescriptLspPath = "./node_modules/rescript-vscode/server/out/server.js"
  --
  -- if not configs.rescript then
  --   configs.rescript = {
  --     default_config = {
  --       cmd = {'node', rescriptLspPath, '--stdio'};
  --       filetypes = {"rescript"};
  --       root_dir = nvim_lsp.util.root_pattern('bsconfig.json');
  --       settings = {};
  --     };
  --   }
  -- end
  -- lsp.register_server(nvim_lsp.rescript)
end

return layer


