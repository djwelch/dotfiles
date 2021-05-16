local plug = require("c.plug")
local keybind = require("c.keybind")
local edit_mode = require("c.edit_mode")

local layer = {}

function layer.register_plugins()
  plug.add_plugin("nvim-lua/popup.nvim")
  plug.add_plugin("nvim-lua/plenary.nvim")
  plug.add_plugin("nvim-telescope/telescope.nvim")
end

function layer.init_config()

  require("telescope").setup {}

  keybind.set_group_name("<leader>f", "Files")
  keybind.bind_command(edit_mode.NORMAL, "<leader>fF", ":Telescope find_files<CR>", { noremap = true }, "Find files")
  keybind.bind_command(edit_mode.NORMAL, "<leader>ff", ":Telescope git_files<CR>", { noremap = true }, "Find files (git)")
  keybind.bind_command(edit_mode.NORMAL, "<leader>fi", ":Telescope live_grep<CR>", { noremap = true }, "Grep files")
  keybind.bind_command(edit_mode.NORMAL, "<leader>fb", ":Telescope buffers<CR>", { noremap = true }, "Find buffer")
  keybind.bind_command(edit_mode.NORMAL, "<leader>ld", ":Telescope lsp_workspace_diagnostics<CR>", { noremap = true }, "Document symbol list")

--  keybind.bind_command(edit_mode.NORMAL, "<leader>fr", ":History<CR>", { noremap = true }, "Recent files")
--  keybind.bind_command(edit_mode.NORMAL, "<leader>fa", ":Ag<CR>", { noremap = true }, "Ag search")
--  keybind.bind_command(edit_mode.NORMAL, "<leader>fc", ":cd %:p:h<CR>", { noremap = true }, "cd")

--  keybind.set_group_name("<leader>g", "Git")
--  keybind.bind_command(edit_mode.NORMAL, "<leader>gs", ":Git<CR>", { noremap = true }, "Git status")
--  keybind.bind_command(edit_mode.NORMAL, "<leader>gp", ":Git push<CR>", { noremap = true }, "Git push")

end

return layer

