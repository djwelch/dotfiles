--- Rust layer
-- @module l.rust

local file = require("c.file")
local plug = require("c.plug")

local layer = {}

--- Returns plugins required for this layer
function layer.register_plugins()
  plug.add_plugin("alx741/vim-rustfmt")
end

--- Configures vim and plugins for this layer
function layer.init_config()
  local lsp = require("l.lsp")
  local build = require("l.build")
  local nvim_lsp = require("lspconfig")

  -- lsp.register_server(nvim_lsp.rls)
  lsp.register_server(nvim_lsp.rust_analyzer)

  -- Ignore cargo output
  file.add_to_wildignore("target")

  build.make_builder()
    :with_filetype("rust")
    :with_prerequisite_file("Cargo.toml")
    :with_build_command("cargo build")
    :with_test_command("cargo test")
    :with_run_command("cargo run")
    :add()
end

return layer
