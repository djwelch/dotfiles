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
  plug.add_plugin("vim-airline/vim-airline") -- Sweet looking status line
  plug.add_plugin("vim-airline/vim-airline-themes") -- Sweet looking status line
  plug.add_plugin("kristijanhusak/vim-hybrid-material") -- Colorscheme
  plug.add_plugin("https://gitlab.com/CraftedCart/vim-indent-guides") -- Indent guides
  plug.add_plugin("jaxbot/semantic-highlight.vim") -- Raiiiiiiinbow coloring!
  plug.add_plugin('kdav5758/TrueZen.nvim')
  plug.add_plugin('lervag/vimtex')
end

--- Configures vim and plugins for this layer
function layer.init_config()
  local true_zen = require("true-zen")
  -- setup for TrueZen.nvim
  true_zen.setup({
    true_false_commands = false,
    cursor_by_mode = false,
    bottom = {
      hidden_laststatus = 0,
      hidden_ruler = false,
      hidden_showmode = false,
      hidden_showcmd = false,
      hidden_cmdheight = 1,
      shown_laststatus = 2,
      shown_ruler = true,
      shown_showmode = false,
      shown_showcmd = false,
      shown_cmdheight = 1
    },
    top = {
      hidden_showtabline = 0,
      shown_showtabline = 2
    },
    left = {
      hidden_number = false,
      hidden_relativenumber = false,
      hidden_signcolumn = "no",
      shown_number = true,
      shown_relativenumber = false,
      shown_signcolumn = "no"
    },
    ataraxis = {
      ideal_writing_area_width = 80,
      just_do_it_for_me = true,
      left_padding = 0,
      right_padding = 0,
      top_padding = 0,
      bottom_padding = 0,
      custome_bg = "",
      disable_bg_configuration = true,
      disable_fillchars_configuration = false,
      force_when_plus_one_window = false,
      force_hide_statusline = true
    },
    focus = {
      margin_of_error = 5,
      focus_method = "experimental"
    },
    events = {
      before_minimalist_mode_shown = false,
      before_minimalist_mode_hidden = false,
      after_minimalist_mode_shown = false,
      after_minimalist_mode_hidden = false
    },
    integrations = {
      integration_galaxyline = false,
      integration_vim_airline = false,
      integration_vim_powerline = false,
      integration_tmux = false,
      integration_express_line = false,
      integration_gitgutter = false,
      integration_vim_signify = false,
      integration_limelight = false,
      integration_tzfocus_tzataraxis = false,
      integration_gitsigns = false
    }
  })
  -- Colors
  vim.o.termguicolors = true
  autocmd.bind_colorscheme(function()
    vim.cmd("highlight DiffAdd ctermfg=193 ctermbg=none guifg=#66CC6C guibg=none")
    vim.cmd("highlight DiffChange ctermfg=189 ctermbg=none guifg=#B166CC guibg=none")
    vim.cmd("highlight DiffDelete ctermfg=167 ctermbg=none guifg=#CC6666 guibg=none")
  end)
  vim.api.nvim_command("colorscheme hybrid_reverse")
  vim.g.airline_theme = "hybridline"

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

  -- Use vim-airline's tabline, and enable powerline symbols
  vim.g.airline_powerline_fonts = 1
  vim.g["airline#extensions#tabline#enabled"] = 1

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
  autocmd.bind("VimEnter,Colorscheme *", function()
    vim.cmd("hi IndentGuidesEven ctermbg=0 guibg=#2E3032")
    vim.cmd("hi IndentGuidesOdd ctermbg=0 guibg=#2E3032")
  end)
  
  terminal.init_config()

  local highlight_langs = {
    "c",
    "cpp",
    "d",
    "python",
    "javascript",
    "typescript",
    "lua",
    "rust",
  }

  autocmd.bind_buf_enter(function()
    if vim.tbl_contains(highlight_langs, vim.bo.filetype) then
      vim.cmd("SemanticHighlight")
    end
  end)
  autocmd.bind_buf_write_post(function()
    if vim.tbl_contains(highlight_langs, vim.bo.filetype) then
      vim.cmd("SemanticHighlight")
    end
  end)
  autocmd.bind_vim_enter(function()
    if vim.tbl_contains(highlight_langs, vim.bo.filetype) then
      vim.cmd("SemanticHighlight")
    end
  end)
end

return layer
