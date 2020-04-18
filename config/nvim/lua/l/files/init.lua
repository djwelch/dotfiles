local plug = require("c.plug")
local keybind = require("c.keybind")
local edit_mode = require("c.edit_mode")

local layer = {}

function layer.register_plugins()
  plug.add_plugin("junegunn/fzf")
  plug.add_plugin("junegunn/fzf.vim")
  plug.add_plugin("tpope/vim-fugitive")
end

function layer.init_config()

  keybind.set_group_name("<leader>f", "Files")
  keybind.bind_command(edit_mode.NORMAL, "<leader>bb", ":Buffers<CR>", { noremap = true }, "Find buffer")
  keybind.bind_command(edit_mode.NORMAL, "<leader>fr", ":History<CR>", { noremap = true }, "Recent files")
  keybind.bind_command(edit_mode.NORMAL, "<leader>fa", ":Ag<CR>", { noremap = true }, "Ag search")
  keybind.bind_command(edit_mode.NORMAL, "<leader>ff", ":Files<CR>", { noremap = true }, "Find files")
  keybind.bind_command(edit_mode.NORMAL, "<leader>fg", ":GitFiles<CR>", { noremap = true }, "Find git files")
  keybind.bind_command(edit_mode.NORMAL, "<leader>fc", ":cd %:p:h<CR>", { noremap = true }, "cd")

end

return layer
