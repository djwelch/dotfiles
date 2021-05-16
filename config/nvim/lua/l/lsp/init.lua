-- Language server protocol support, courtesy of Neovim
-- @module l.lsp

local keybind = require("c.keybind")
local edit_mode = require("c.edit_mode")
local autocmd = require("c.autocmd")
local plug = require("c.plug")
local log = require("c.log")
local class = require("c.class")
local Signal = require("c.signal").Signal

local layer = {}

local ClientProgress = class.strict {
  title = "...",
  message = class.NULL,
  percentage = class.NULL,
}

layer.util = require("l.lsp.util")
layer.client_progress = {}
layer.signal_progress_update = Signal()

--- Returns plugins required for this layer
function layer.register_plugins()
  -- plug.add_plugin("neovim/nvim-lsp")
  plug.add_plugin("haorenW1025/completion-nvim")
end

local function user_stop_all_clients()
  local clients = vim.lsp.get_active_clients()

  if #clients > 0 then
    vim.lsp.stop_client(clients)
    for _, v in pairs(clients) do
      print("Stopped LSP client " .. v.name)
    end
  else
    print("No LSP clients are running")
  end
end

local function user_attach_client()
  local filetype = vim.bo[0].filetype

  local server = layer.filetype_servers[filetype]
  if server ~= nil then
    print("Attaching LSP client " .. server.config.name .. " to buffer")

    local root_dir = server.config.root_dir(vim.api.nvim_buf_get_name(0), vim.api.nvim_get_current_buf())
    if root_dir then
      local id = server.manager.add(root_dir)
      if id then
        vim.lsp.buf_attach_client(0, id)
      else
        print("Could not start LSP")
      end
    else
      print("No root_dir found for LSP")
    end
  else
    print("No LSP client registered for filetype " .. filetype)
  end
end

--- Configures vim and plugins for this layer
function layer.init_config()
  vim.lsp.set_log_level("trace")

  vim.fn.sign_define('LspDiagnosticsSignError', { text = "❌", texthl = "LspDiagnosticsDefaultError" })
  vim.fn.sign_define('LspDiagnosticsSignWarning', { text = "⚠️", texthl = "LspDiagnosticsDefaultWarning" })
  vim.fn.sign_define('LspDiagnosticsSignInformation', { text = "❓", texthl = "LspDiagnosticsDefaultInformation" })
  vim.fn.sign_define('LspDiagnosticsSignHint', { text = "💡", texthl = "LspDiagnosticsDefaultHint" })

  vim.api.nvim_set_var("completion_enable_in_comment", 1)
  vim.api.nvim_set_var("completion_confirm_key", "") -- I just use tab, plus also this conflicts with auto-pairs
  vim.api.nvim_set_var("completion_trigger_on_delete", 1)

  if plug.has_plugin("ultisnips") then
    vim.g.completion_enable_snippet = "UltiSnips"
  end

  -- Bind leader keys
  keybind.set_group_name("<leader>l", "LSP")
  keybind.bind_function(edit_mode.NORMAL, "<leader>lS", user_stop_all_clients, nil, "Stop all LSP clients")
  keybind.bind_function(edit_mode.NORMAL, "<leader>lA", user_attach_client, nil, "Attach LSP client to buffer")

  -- Tabbing
  keybind.bind_command(edit_mode.INSERT, "<tab>", "pumvisible() ? '<C-n>' : '<tab>'", { noremap = true, expr = true })
  keybind.bind_command(edit_mode.INSERT, "<S-tab>", "pumvisible() ? '<C-p>' : '<S-tab>'", { noremap = true, expr = true })
  autocmd.bind_complete_done(function()
    if vim.fn.pumvisible() == 0 then
      vim.cmd("pclose")
    end
  end)

  vim.o.completeopt = "menuone,noinsert,noselect"

  -- Jumping to places
  autocmd.bind_filetype("*", function()
    local server = layer.filetype_servers[vim.bo.ft]
    if server ~= nil then
      keybind.buf_bind_command(edit_mode.NORMAL, "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true })
      keybind.buf_bind_command(edit_mode.NORMAL, "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true })
      keybind.buf_bind_command(edit_mode.NORMAL, "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { noremap = true })
      keybind.buf_bind_command(edit_mode.NORMAL, "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { noremap = true })
      keybind.buf_bind_command(edit_mode.NORMAL, "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { noremap = true })
      keybind.buf_bind_command(edit_mode.NORMAL, "]g", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", { noremap = true })
      keybind.buf_bind_command(edit_mode.NORMAL, "[g", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", { noremap = true })

      user_attach_client()
    end
  end)

  keybind.bind_command(edit_mode.NORMAL, "<leader>=", "<cmd>lua vim.lsp.buf.formatting()<CR>", { noremap = true }, "Format")

  -- Show docs when the cursor is held over something
  autocmd.bind_cursor_hold(function()
     -- vim.cmd("lua require'nvim-lightbulb'.update_lightbulb()")
  end)

end

--- Maps filetypes to their server definitions
--
-- <br>
-- Eg: `["rust"] = lspconfig.rls`
--
-- <br>
-- See `lspconfig` for what a server definition looks like
layer.filetype_servers = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.window = capabilities.window or {}
capabilities.window.workDoneProgress = true
capabilities.workspace = capabilities.workspace or {}
capabilities.workspace.configuration = true

local configuredDiagnosticsHandler = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = false,
    signs = true,
    virtual_text = false,
    update_in_insert = false,
  })

--- Register an LSP server
--
-- @param server An LSP server definition (in the format expected by `lspconfig`)
-- @param config The config for the server (in the format expected by `lspconfig`)
function layer.register_server(config)
  local completion = require("completion") -- From completion-nvim

  local server = {}
  server.config = vim.tbl_extend("keep", {}, config)
  server.config.on_attach = completion.on_attach
  server.config.capabilities = capabilities
  server.config.settings = {}
  server.config.handlers = server.config.handlers or {}

  server.config.handlers["textDocument/publishDiagnostics"] = server.config.handlers["textDocument/publishDiagnostics"] or configuredDiagnosticsHandler

  server.config.handlers["workspace/configuration"] = function(err, method, params, client_id)
      log.log(params);
      if err then error(tostring(err)) end
      if not params.items then
        return {}
      end

      local result = {}
      for _, item in ipairs(params.items) do
        if item.section then
          local value = util.lookup_section(server.config.settings, item.section) or vim.NIL
          table.insert(result, value)
        end
      end
      return result
    end

  server.manager = layer.util.server_per_root_dir_manager(function(_root_dir)
    local new_config = vim.tbl_extend("keep", {}, server.config)
    new_config.root_dir = _root_dir
    return new_config
  end)

  for _, v in pairs(server.config.filetypes) do
    layer.filetype_servers[v] = server
  end
end

return layer
