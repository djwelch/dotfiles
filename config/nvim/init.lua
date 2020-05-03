local reload = require("c.reload")
reload.unload_user_modules()

local log = require("c.log")
log.init()

local layer = require("c.layer")
local keybind = require("c.keybind")
local autocmd = require("c.autocmd")

keybind.register_plugins()
autocmd.init()


layer.add_layer("l.editor")
layer.add_layer("l.style")
layer.add_layer("l.files")
layer.add_layer("l.lsp")
layer.add_layer("l.typescript")

layer.finish_layer_registration()

keybind.post_init()