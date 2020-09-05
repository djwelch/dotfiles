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
end

--- Configures vim and plugins for this layer
function layer.init_config()
  -- Don't create default key bindings
  vim.g.dispatch_no_maps = 1

  keybind.bind_command(edit_mode.NORMAL, "<leader>pc", ":Dispatch<CR>", { noremap = true })
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

