--- C/C++/Objective C layer
-- @module l.c_cpp

local layer = {}

--- Returns plugins required for this layer
function layer.register_plugins()
end

--- Configures vim and plugins for this layer
function layer.init_config()
  local lsp = require("l.lsp")
  local build = require("l.build")
  local nvim_lsp = require("nvim_lsp")

  lsp.register_server(nvim_lsp.clangd)

  build.make_builder()
    :with_filetype("c")
    :with_filetype("cpp")
    :with_filetype("cmake")
    :with_prerequisite_file("CMakeLists.txt")
    :with_build_command("mkdir -p ./build && cd ./build && cmake -G Ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE -DCMAKE_CXX_FLAGS='-fdiagnostics-color' .. && ninja")
    :add()

end

return layer
