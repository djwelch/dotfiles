--- C/C++/Objective C layer
-- @module l.c_cpp

local layer = {}

--- Returns plugins required for this layer
function layer.register_plugins()
end

--- Configures vim and plugins for this layer
function layer.init_config()
  local lsp = require("l.lsp")
--  local build = require("l.build")

  lsp.register_server({
    name = "c_cpp";
    cmd = {"clangd", "--background-index", "--compile-commands-dir=./.build" };
    filetypes = {"c", "cpp"};
    root_dir = lsp.util.root_pattern('CMakeLists.txt');
    handlers = handlers;
  })

--  build.make_builder()
--    :with_filetype("c")
--    :with_filetype("cpp")
--    :with_filetype("cmake")
--    :with_prerequisite_file("CMakeLists.txt")
--    :with_build_command("./build.sh")
--    :add()

end

return layer
