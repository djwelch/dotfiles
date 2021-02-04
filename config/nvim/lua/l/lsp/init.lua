-- Language server protocol support, courtesy of Neovim
-- @module l.lsp

local keybind = require("c.keybind")
local edit_mode = require("c.edit_mode")
local autocmd = require("c.autocmd")
local plug = require("c.plug")
local class = require("c.class")
local Signal = require("c.signal").Signal

local layer = {}

local ClientProgress = class.strict {
  title = "...",
  message = class.NULL,
  percentage = class.NULL,
}

layer.client_progress = {}
layer.signal_progress_update = Signal()

--- Returns plugins required for this layer
function layer.register_plugins()
  plug.add_plugin("neovim/nvim-lsp")
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
    print("Attaching LSP client " .. server.name .. " to buffer")
    server.manager.try_add()
  else
    print("No LSP client registered for filetype " .. filetype)
  end
end

--- Get the LSP status line part for vim-airline
function layer._get_airline_part()
  local clients = vim.lsp.buf_get_clients()
  local client_names = {}
  for _, v in pairs(clients) do
    table.insert(client_names, v.name)
  end

  if #client_names > 0 then
    local sections = { "LSP:", table.concat(client_names, ", ") }

    local error_count = vim.lsp.diagnostic.get_count("Error")
    if error_count ~= nil and error_count > 0 then table.insert(sections, "E: " .. error_count) end

    local warn_count = vim.lsp.diagnostic.get_count("Warning")
    if error_count ~= nil and warn_count > 0 then table.insert(sections, "W: " .. warn_count) end

    local info_count = vim.lsp.diagnostic.get_count("Information")
    if error_count ~= nil and info_count > 0 then table.insert(sections, "I: " .. info_count) end

    local hint_count = vim.lsp.diagnostic.get_count("Hint")
    if error_count ~= nil and hint_count > 0 then table.insert(sections, "H: " .. hint_count) end

    return table.concat(sections, " ")
  else
    return ""
  end
end

local function on_progress(err, method, result, client_id, buf_num, config)
  if err ~= nil then return end

  if result.value.kind == "end" then
    layer.client_progress[client_id] = nil
  else
    local prog = layer.client_progress[client_id]
    if prog == nil then
      prog = ClientProgress()
      layer.client_progress[client_id] = prog
    end

    prog.title = result.value.title or prog.title
    prog.message = result.value.message or prog.message

    -- So the LSP spec says percentage should be a value between 0 - 100
    -- but some clients (like ccls) give a value between 0 - 1
    -- so here's a kludgey workaround
    if result.value.percentage ~= nil then
      local percent = result.value.percentage
      if percent <= 1 then
        prog.percentage = percent
      else
        prog.percentage = percent / 100
      end
    end
  end


  layer.signal_progress_update:emit()
end

--- Configures vim and plugins for this layer
function layer.init_config()
  -- We want to recieve progress messages
  vim.lsp.handlers['$/progress'] = on_progress

  vim.api.nvim_set_var("completion_enable_in_comemnt", 1)
  vim.api.nvim_set_var("completion_confirm_key", "") -- I just use tab, plus also this conflicts with auto-pairs
  vim.api.nvim_set_var("completion_trigger_on_delete", 1)

  if plug.has_plugin("ultisnips") then
    vim.g.completion_enable_snippet = "UltiSnips"
  end

  -- Bind leader keys
  keybind.set_group_name("<leader>l", "LSP")
  keybind.bind_function(edit_mode.NORMAL, "<leader>ls", user_stop_all_clients, nil, "Stop all LSP clients")
  keybind.bind_function(edit_mode.NORMAL, "<leader>la", user_attach_client, nil, "Attach LSP client to buffer")

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
      keybind.buf_bind_command(edit_mode.NORMAL, "gd", ":lua vim.lsp.buf.declaration()<CR>", { noremap = true })
      keybind.buf_bind_command(edit_mode.NORMAL, "gD", ":lua vim.lsp.buf.implementation()<CR>", { noremap = true })
      keybind.buf_bind_command(edit_mode.NORMAL, "<C-]>", ":lua vim.lsp.buf.definition()<CR>", { noremap = true })
      keybind.buf_bind_command(edit_mode.NORMAL, "K", ":lua vim.lsp.buf.hover()<CR>", { noremap = true })
      -- keybind.bind_command(edit_mode.NORMAL, "<C-k>", ":lua vim.lsp.buf.signature_help()<CR>", { noremap = true })
    end
  end)

  keybind.bind_command(edit_mode.NORMAL, "<leader>lr", ":lua vim.lsp.buf.references()<CR>", { noremap = true }, "Find references")
  keybind.bind_command(edit_mode.NORMAL, "<leader>lR", ":lua vim.lsp.buf.rename()<CR>", { noremap = true }, "Rename")
  keybind.bind_command(edit_mode.NORMAL, "<leader>ld", ":lua vim.lsp.buf.document_symbol()<CR>", { noremap = true }, "Document symbol list")
  keybind.bind_command(edit_mode.NORMAL, "<leader>lf", ":lua vim.lsp.buf.code_action()<CR>", { noremap = true }, "Code actions")

  keybind.set_group_name("<leader>j", "Jump")
  keybind.bind_command(edit_mode.NORMAL, "<leader>jd", ":lua vim.lsp.buf.declaration()<CR>", { noremap = true }, "Jump to declaration")
  keybind.bind_command(edit_mode.NORMAL, "<leader>ji", ":lua vim.lsp.buf.implementation()<CR>", { noremap = true }, "Jump to implementation")
  keybind.bind_command(edit_mode.NORMAL, "<leader>jf", ":lua vim.lsp.buf.definition()<CR>", { noremap = true }, "Jump to definition")

  -- Show docs when the cursor is held over something
  -- autocmd.bind_cursor_hold(function()
    -- vim.cmd("lua vim.lsp.buf.hover()")
  -- end)

  -- Show in vim-airline the attached LSP client
  if plug.has_plugin("vim-airline") then
    vim.api.nvim_exec(
      [[
      function! CLspGetAirlinePart()
        return luaeval("require('l.lsp')._get_airline_part()")
      endfunction
      ]],
      false
      )
    vim.fn["airline#parts#define_function"]("c_lsp", "CLspGetAirlinePart")
    vim.fn["airline#parts#define_accent"]("c_lsp", "yellow")
    vim.g.airline_section_y = vim.fn["airline#section#create_right"]{"c_lsp", "ffenc"}
  end
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

--- Register an LSP server
--
-- @param server An LSP server definition (in the format expected by `lspconfig`)
-- @param config The config for the server (in the format expected by `lspconfig`)
function layer.register_server(server, config)
  local completion = require("completion") -- From completion-nvim

  config = config or {}
  config.on_attach = completion.on_attach
  config = vim.tbl_extend("keep", config, server.document_config.default_config)

  -- We want to recieve progress messages
  config.capabilities = vim.tbl_extend('keep', config.capabilities or {}, capabilities)

  server.setup(config)

  for _, v in pairs(config.filetypes) do
    layer.filetype_servers[v] = server
  end
end

return layer
