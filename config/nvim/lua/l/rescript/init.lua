--- Rescript layer
-- @module l.rescript
local plug = require("c.plug")

local layer = {}

--- Returns plugins required for this layer
function layer.register_plugins()
  plug.add_plugin("rescript-lang/vim-rescript")
  -- plug.add_plugin("reasonml-editor/vim-reason-plus")
end


local configuredDiagnosticsHandler = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = false,
    signs = true,
    virtual_text = false,
    update_in_insert = false,
  })
local function handleDiagnostics(err, method, params, client_id, bufnr, config)
  params.uri = "file://" .. params.uri
  configuredDiagnosticsHandler(err, method, params, client_id, bufnr, config)
end

--- Configures vim and plugins for this layer
function layer.init_config()
  local lsp = require("l.lsp")
  local rescriptLspPath = "/home/david/.local/opt/rescript-vscode/server/out/server.js"
  
  local handlers = {}
  handlers["textDocument/publishDiagnostics"] = handleDiagnostics

  lsp.register_server({
    name = "rescript";
    cmd = {"node", rescriptLspPath, '--stdio'};
    filetypes = {"rescript"};
    root_dir = lsp.util.root_pattern('bsconfig.json');
    handlers = handlers;
  })
end

return layer


