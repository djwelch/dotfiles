--- Build layer
-- @module l.build

local plug = require("c.plug")
local keybind = require("c.keybind")
local edit_mode = require("c.edit_mode")
local autocmd = require("c.autocmd")
local file = require("c.file")

local layer = {}

--- Returns plugins required for this layer
function layer.register_plugins()
  plug.add_plugin("tpope/vim-dispatch")
  plug.add_plugin("radenling/vim-dispatch-neovim")
end

--- Configures vim and plugins for this layer
function layer.init_config()
  -- Don't create default key bindings
  vim.g.dispatch_no_maps = 1

  keybind.bind_command(edit_mode.NORMAL, "<leader>pc", ":Dispatch<CR>", { noremap = true })
  keybind.bind_function(
    edit_mode.NORMAL,
    "<leader>pt",
    function()
      local test_cmd = vim.b.c_dispatch_test
      if test_cmd ~= nil then
        vim.cmd("Dispatch " .. test_cmd)
      else
        print("No test command configured! (Buffer variable 'c_dispatch_test' missng)")
      end
    end,
    { noremap = true },
    "Test"
  )
  keybind.bind_function(
    edit_mode.NORMAL,
    "<leader>pr",
    function()
      local run_cmd = vim.b.c_dispatch_run
      if run_cmd ~= nil then
        vim.cmd("Start " .. run_cmd)
      else
        print("No run command configured! (Buffer variable 'c_dispatch_run' missng)")
      end
    end,
    { noremap = true },
    "Run"
  )

end

local Builder = {
  with_filetype = function(self, filetype)
    table.insert(self.filetypes, filetype)
    return self
  end,

  with_build_command = function(self, command)
    self.build_command = command
    return self
  end,

  with_test_command = function(self, command)
    self.test_command = command
    return self
  end,

  with_run_command = function(self, command)
    self.run_command = command
    return self
  end,

  with_prerequisite_file = function(self, file)
    table.insert(self.prerequisite_files, file)
    return self
  end,

  add = function(self)
    assert(self.build_command ~= nil)
    assert(#self.filetypes > 0)

    autocmd.bind_filetype(self.filetypes, function()
      -- Check prereq files exist
      for _, f in pairs(self.prerequisite_files) do
        if not file.is_readable(f) then return end
      end

      -- Set the build command
      vim.api.nvim_buf_set_var(0, "dispatch", self.build_command)

      if self.test_command ~= nil then
        -- Set the test command
        -- "b:c_dispatch_test" used in config, not a vim-dispatch thing
        vim.api.nvim_buf_set_var(0, "c_dispatch_test", self.test_command)
      end
      if self.run_command ~= nil then
        -- Set the run command
        -- "b:c_dispatch_run" used in config, not a vim-dispatch thing
        vim.api.nvim_buf_set_var(0, "c_dispatch_run", self.run_command)
      end
    end)
  end,
}

function layer.make_builder()
  local builder = {
    filetypes = {},
    build_command = nil,
    prerequisite_files = {},
  }
  setmetatable(builder, { __index = Builder })

  return builder
end

return layer

