--- Rescript layer
-- @module l.rescript
local plug = require("c.plug")
local keybind = require("c.keybind")
local edit_mode = require("c.edit_mode")

local layer = {}

--- Returns plugins required for this layer
function layer.register_plugins()
  plug.add_plugin("rescript-lang/vim-rescript")
  plug.add_plugin("vim-test/vim-test")
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
  keybind.set_group_name("<leader>t", "Test")
  keybind.bind_command(edit_mode.NORMAL, "<leader>tn", ":TestNearest<CR>", { noremap = true })
  keybind.bind_command(edit_mode.NORMAL, "<leader>tf", ":TestFile<CR>", { noremap = true })
  keybind.bind_command(edit_mode.NORMAL, "<leader>ts", ":TestSuite<CR>", { noremap = true })
  keybind.bind_command(edit_mode.NORMAL, "<leader>tl", ":TestLast<CR>", { noremap = true })
  keybind.bind_command(edit_mode.NORMAL, "<leader>tv", ":TestVisit<CR>", { noremap = true })

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


