--- The styling layer
-- @module l.style

local layer = {}

local plug = require("c.plug")
local autocmd = require("c.autocmd")

local terminal = require("l.style.terminal")

-- The startup buffer doesn't seem to pick up on vim.o changes >.<
local function set_default_win_opt(name, value)
  vim.o[name] = value
  autocmd.bind_vim_enter(function()
    vim.wo[name] = value
  end)
end

--- Returns plugins required for this layer
function layer.register_plugins()
  plug.add_plugin("https://gitlab.com/CraftedCart/vim-indent-guides") -- Indent guides
  plug.add_plugin('lervag/vimtex')
  -- plug.add_plugin('vim-latex/vim-latex')
  plug.add_plugin('folke/tokyonight.nvim')
end

--- Configures vim and plugins for this layer
function layer.init_config()
  -- Colors
  vim.o.termguicolors = true
  vim.api.nvim_command("colorscheme tokyonight")

  -- Shorten updatetime from the default 4000 for quicker CursorHold updates
  -- Used for stuff like the VCS gutter updates
  vim.o.updatetime = 750

  -- Allow hidden buffers
  vim.o.hidden = true

  -- Line numbers and relative line numbers
  set_default_win_opt("number", true)
  set_default_win_opt("relativenumber", true)

  -- Highlight the cursor line
  set_default_win_opt("cursorline", true)

  -- Incremental search and incremental find/replace
  vim.o.incsearch = true
  vim.o.inccommand = "split"

  -- Use case-insensitive search if the entire search query is lowercase
  vim.o.ignorecase = true
  vim.o.smartcase = true

  -- Highlight while searching
  vim.o.hlsearch = true

  -- Faster redrawing
  vim.o.lazyredraw = true

  -- Open splits on the right
  vim.o.splitright = true
  vim.o.splitbelow = true

  -- Show tabs and trailing whitespace
  set_default_win_opt("list", true)
  set_default_win_opt("listchars", "tab:│ ,eol: ,trail:·")

  -- Scroll 12 lines/columns before the edges of a window
  vim.o.scrolloff = 12
  vim.o.sidescrolloff = 12

  -- Show partial commands in the bottom right
  vim.o.showcmd = true

  -- Show line at column 120
  set_default_win_opt("colorcolumn", "85")

  -- Enable mouse support
  vim.o.mouse = "a"

  -- 200ms timeout before which-key kicks in
  vim.g.timeoutlen = 200

  -- Reposition the which-key float slightly
  vim.g.which_key_floating_opts = { row = 1, col = -3, width = 3 }

  -- Always show the sign column
  set_default_win_opt("signcolumn", "yes")

  -- Configure indent guides
  vim.g.indent_guides_enable_on_vim_startup = 1
  vim.g.indent_guides_auto_colors = 0
  vim.g.indent_guides_guide_size = 1
  vim.g.indent_guides_exclude_filetypes = {
    "help",
  }
  vim.g.indent_guides_exclude_noft = 1
  vim.g.indent_guides_default_mapping = 0

  terminal.init_config()
end

return layer
