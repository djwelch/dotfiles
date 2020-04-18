--- User-specific editor tweaks
-- @module l.editor

local plug = require("c.plug")
local keybind = require("c.keybind")
local edit_mode = require("c.edit_mode")
local autocmd = require("c.autocmd")

local layer = {}

-- The startup buffer doesn't seem to pick up on vim.o changes >.<
local function set_default_buf_opt(name, value)
  vim.o[name] = value
  autocmd.bind_vim_enter(function()
    vim.bo[name] = value
  end)
end

--- Returns plugins required for this layer
function layer.register_plugins()
end

--- Configures vim and plugins for this layer
function layer.init_config()
  -- Space for leader, comma for local leader
  vim.g.mapleader = " "
  vim.g.maplocalleader = ","

  -- Save undo history
  set_default_buf_opt("undofile", true)

  -- M-h/j/k/l to resize windows
  keybind.bind_command(edit_mode.NORMAL, "<M-h>", ":vertical resize -1<CR>", { noremap = true })
  keybind.bind_command(edit_mode.NORMAL, "<M-j>", ":resize -1<CR>", { noremap = true })
  keybind.bind_command(edit_mode.NORMAL, "<M-k>", ":resize +1<CR>", { noremap = true })
  keybind.bind_command(edit_mode.NORMAL, "<M-l>", ":vertical resize +1<CR>", { noremap = true })

  -- C-h/j/k/l to move between windows
  keybind.bind_command(edit_mode.NORMAL, "<C-h>", "<C-w>h", { noremap = true })
  keybind.bind_command(edit_mode.NORMAL, "<C-j>", "<C-w>j", { noremap = true })
  keybind.bind_command(edit_mode.NORMAL, "<C-k>", "<C-w>k", { noremap = true })
  keybind.bind_command(edit_mode.NORMAL, "<C-l>", "<C-w>l", { noremap = true })

  -- Edit config, reload config, and update plugins
  keybind.set_group_name("<leader>fe", "Editor")
  keybind.bind_command(edit_mode.NORMAL, "<leader>fed", ":edit $HOME/.config/nvim<CR>", { noremap = true }, "Edit config")
  keybind.bind_command(edit_mode.NORMAL, "<leader>feR", ":source $MYVIMRC<CR>", { noremap = true }, "Reload config")
  keybind.bind_command(edit_mode.NORMAL, "<leader>feU", ":source $MYVIMRC|PlugUpgrade|PlugClean|PlugUpdate|source $MYVIMRC<CR>", {noremap = true}, "Install and update plugins")

  -- Buffer
  keybind.set_group_name("<leader>b", "Buffers")
  keybind.bind_command(edit_mode.NORMAL, "<leader>bn", ":enew<CR>", { noremap = true }, "New buffer")
  keybind.bind_command(edit_mode.NORMAL, "<leader>bd", ":bd<CR>", { noremap = true }, "Unload buffer")

  -- Default indentation rules
  set_default_buf_opt("tabstop", 2)
  set_default_buf_opt("softtabstop", 2)
  set_default_buf_opt("shiftwidth", 2)
  set_default_buf_opt("expandtab", true) -- Use spaces instead of tabs
  set_default_buf_opt("autoindent", true)
  set_default_buf_opt("smartindent", true)
  -- Keep visual selection while indenting
  keybind.bind_command(edit_mode.VISUAL_SELECT, "<", "<gv", { noremap = true, silent = true })
  keybind.bind_command(edit_mode.VISUAL_SELECT, ">", ">gv", { noremap = true, silent = true })
  -- A-j/k to move lines up/down
  keybind.bind_command(edit_mode.NORMAL, "<A-j>", ":m .+1<CR>==", { noremap = true, silent = true })
  keybind.bind_command(edit_mode.NORMAL, "<A-k>", ":m .-2<CR>==", { noremap = true, silent = true })
  keybind.bind_command(edit_mode.INSERT, "<A-j>", "<ESC>:m .+1<CR>==gi", { noremap = true, silent = true })
  keybind.bind_command(edit_mode.INSERT, "<A-k>", "<ESC>:m .-2<CR>==gi", { noremap = true, silent = true })
  keybind.bind_command(edit_mode.VISUAL_SELECT, "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
  keybind.bind_command(edit_mode.VISUAL_SELECT, "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
  -- Allow movement to move logically between lines
  keybind.bind_command(edit_mode.NORMAL, "j", "gj", { noremap = true, silent = true })
  keybind.bind_command(edit_mode.NORMAL, "k", "gk", { noremap = true, silent = true })

end

return layer
