--- File management
-- @module l.file_man

local plug = require("c.plug")
local keybind = require("c.keybind")
local edit_mode = require("c.edit_mode")

local layer = {}

--- Returns plugins required for this layer
function layer.register_plugins()
  plug.add_plugin("preservim/nerdtree")
  plug.add_plugin("ctrlpvim/ctrlp.vim")
end

--- Configures vim and plugins for this layer
function layer.init_config()
  keybind.bind_command(edit_mode.NORMAL, "<leader>0", ":NERDTreeFocus<CR>", { noremap = true },
      "Focus file tree")
  keybind.bind_command(edit_mode.NORMAL, "<leader>pt", ":NERDTreeToggle<CR>", { noremap = true },
      "Toggle file tree")

  -- <leader>b group name is set in l.editor
  keybind.set_group_name("<leader>p", "Projects")
  keybind.set_group_name("<leader>f", "Files")

  keybind.bind_command(edit_mode.NORMAL, "<leader>pf", ":CtrlP<CR>", { noremap = true },
      "Find file")
  keybind.bind_command(edit_mode.NORMAL, "<leader>bb", ":CtrlPBuffer<CR>", { noremap = true },
      "Find buffer")
  keybind.bind_command(edit_mode.NORMAL, "<leader>fr", ":CtrlPMRU<CR>", { noremap = true },
      "Recent files")

  -- Disable default binding
  vim.api.nvim_set_var("ctrlp_map", "")

  -- Show hidden files
  vim.api.nvim_set_var("NERDTreeShowHidden", 1)
end

return layer
