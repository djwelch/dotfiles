--- Command management
-- @module c.command

local command = {}

command._bound_funcs = {}

--- Makes a new command to call a Lua function
--
-- The Lua function will recieve 2 params, `arg_string`, and `opts`
-- `opts` contains
-- - `bang: boolean`: Whether the command was called with an exclamation mark at the end
--
-- @tparam string cmd The command name
-- @tparam function func The function to call with args as func(arg_string, opts)
-- @tparam[opt] int|string num_args see `:help :command-nargs`
-- @tparam[opt] table opts Additional options (eg: `{ bang = true }`)
function command.make_command(cmd, func, num_args, opts)
  num_args = num_args or 0
  opts = opts or {}

  local func_name = "cmd_" .. cmd

  local func_name_escaped = func_name
  -- Escape Lua things
  func_name_escaped = func_name_escaped:gsub("'", "\\'")
  func_name_escaped = func_name_escaped:gsub('"', '\\"')
  func_name_escaped = func_name_escaped:gsub("\\[", "\\[")
  func_name_escaped = func_name_escaped:gsub("\\]", "\\]")

  -- Escape VimScript things
  -- We only escape `<` - I couldn't be bothered to deal with how <lt>/<gt> have angle brackets in themselves
  -- And this works well-enough anyways
  func_name_escaped = func_name_escaped:gsub("<", "<lt>")

  command._bound_funcs[func_name] = func

  local lua_command = "lua require('c.command')._bound_funcs['" .. func_name_escaped .. "']('<args>', { bang = '<bang>' == '!' })"
  local bang = opts.bang and "-bang " or ""
  vim.cmd("command! -nargs=" .. num_args .. " " .. bang .. cmd .. " " .. lua_command)
end

return command

