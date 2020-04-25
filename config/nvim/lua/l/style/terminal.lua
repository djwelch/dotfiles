--- Terminal UI
-- @module l.style.terminal

local edit_mode = require("c.edit_mode")
local keybind = require("c.keybind")
local autocmd = require("c.autocmd")

local terminal = {}

local TERMINAL_BUF_NAME = "Popup terminal"

local function get_buf_by_name(name)
  for _, v in pairs(vim.api.nvim_list_bufs()) do
    if vim.endswith(vim.api.nvim_buf_get_name(v), name) then
      return v
    end
  end

  return nil
end

local function find_win_with_buf(buf)
  local tabpage = vim.api.nvim_get_current_tabpage()

  for _, v in pairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(v) == buf and vim.api.nvim_win_get_tabpage(v) == tabpage then
      return v
    end
  end

  return nil
end

local function open_bottom_split()
  -- Open a window and shove it to the bottom
  vim.cmd("split")
  vim.cmd("wincmd J")
  vim.api.nvim_win_set_height(0, 16)
end

local function open_or_focus_term()
  local terminal_buf = get_buf_by_name(TERMINAL_BUF_NAME)
  if terminal_buf == nil then
    -- We need to create a terminal buffer
    open_bottom_split()
    vim.cmd("terminal")
    vim.api.nvim_buf_set_name(0, TERMINAL_BUF_NAME)
  else
    local terminal_win = find_win_with_buf(terminal_buf)
    if terminal_win == nil then
      open_bottom_split()
      vim.api.nvim_win_set_buf(0, terminal_buf)
    else
      vim.api.nvim_set_current_win(terminal_win)
    end
  end

  -- Enter insert mode
  vim.cmd("startinsert")
end

local function hide_term()
  local terminal_buf = get_buf_by_name(TERMINAL_BUF_NAME)
  if terminal_buf == nil then return end
  local terminal_win = find_win_with_buf(terminal_buf)
  if terminal_win == nil then return end

  vim.api.nvim_win_close(terminal_win, false)
end

-- Save and restore terminal height {{{

local last_term_win_size = nil

local function save_term_win()
  local terminal_buf = get_buf_by_name(TERMINAL_BUF_NAME)
  if terminal_buf == nil then return end
  local terminal_win = find_win_with_buf(terminal_buf)
  if terminal_win == nil then return end

  last_term_win_size = vim.api.nvim_win_get_height(terminal_win)
end

local function restore_term_win()
  local terminal_buf = get_buf_by_name(TERMINAL_BUF_NAME)
  if terminal_buf == nil then return end
  local terminal_win = find_win_with_buf(terminal_buf)
  if terminal_win == nil then return end

  vim.api.nvim_win_set_height(terminal_win, last_term_win_size)
end

-- }}}

function terminal.init_config()
  keybind.set_group_name("<leader>t", "Terminal")
  keybind.bind_function(edit_mode.NORMAL, "<leader>tt", open_or_focus_term, { noremap = true }, "Focus terminal")
  keybind.bind_function(edit_mode.NORMAL, "<leader>tT", hide_term, { noremap = true }, "Hide terminal")
  keybind.bind_command(edit_mode.TERMINAL, "<ESC>", "<C-\\><C-n>", { noremap = true }, "Hide terminal")

  autocmd.bind_quit_pre(save_term_win)
  autocmd.bind_win_closed(function() vim.schedule(restore_term_win) end)
end

return terminal
