--- Treesitter layer
-- @module l.treesitter

local plug = require("c.plug")
local command = require("c.command")

local layer = {}

local function make_ts_indicator_part(expr)
  local start_row, start_col, end_row, end_col = expr:range()
  local line = vim.api.nvim_buf_get_lines(0, start_row, start_row + 1, true)[1]
  if start_row == end_row then
    line = line:sub(start_col + 1, end_col)
  else
    line = line:sub(start_col + 1)
  end

  -- return expr:type() .. " > " .. line
  return string.format("%30s > %s", expr:type(), line)
end

--- Registers plugins required for this layer
function layer.register_plugins()
  plug.add_plugin("nvim-treesitter/nvim-treesitter")
end

--- Configures vim and plugins for this layer
function layer.init_config()
  -- local nvim_treesitter = require("nvim-treesitter")
  local parsers = require("nvim-treesitter.parsers")
  local configs = require("nvim-treesitter.configs")
  local ts_utils = require("nvim-treesitter.ts_utils")

  configs.setup{
    ensure_installed = "all", -- one of "all", "language", or a list of languages
    highlight = {
      -- We use semantic highlight instead
      enable = true,
      disable = {},
    },
    refactor = {
      highlight_definitions = { enable = true },
      highlight_current_scope = { enable = false },
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
    textobjects = {
      select = {
        enable = true,
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",

          -- Or you can define your own textobjects like this
          -- ["iF"] = {
            -- python = "(function_definition) @function",
            -- cpp = "(function_definition) @function",
            -- c = "(function_definition) @function",
            -- java = "(method_declaration) @function",
          -- },
        },
        move = {
          enable = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
      },
    },
  }

  command.make_command("CTsWhat", function(args, opts)
    if not parsers.has_parser() then
      print("No treesitter parser")
    end

    local current_node = ts_utils.get_node_at_cursor()
    if not current_node then return "" end

    local expr = current_node:parent()
    local prefix = ""
    if expr then
      prefix = "\n"
    end

    local indicator = make_ts_indicator_part(current_node)
    while expr do
      local start_row, start_col, end_row, end_col = expr:range()
      local line = vim.api.nvim_buf_get_lines(0, start_row, start_row + 1, true)[1]
      if start_row == end_row then
        line = line:sub(start_col + 1, end_col)
      else
        line = line:sub(start_col + 1)
      end

      indicator = make_ts_indicator_part(expr) .. prefix .. indicator
      expr = expr:parent()
    end

    print(indicator)
  end, 0)
end

return layer

