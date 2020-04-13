if (!exists('g:vscode'))
" General {{{
set hidden
set encoding=utf-8"
set nomodeline
set history=1000
set textwidth=90
set splitbelow splitright
set nobackup
set nowritebackup
set backupcopy=yes
set backspace=indent,eol,start " make backspace behave in a sane manner
set clipboard=unnamed

set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
if (has('nvim'))
  " show results of substition as they're happening
  " but don't open a split
  set inccommand=nosplit
endif

" Searching
set ignorecase " case insensitive searching
set smartcase " case-sensitive if expresson contains a capital letter
set hlsearch " highlight search results
set incsearch " set incremental search, like modern browsers
set nolazyredraw " don't redraw while executing macros

set magic " Set magic on, for regex

" error bells
set noerrorbells
set visualbell
set t_vb=
set tm=500

" }}}
" AutoGroups {{{
" file type specific settings
augroup configgroup
  autocmd!
  " automatically resize panes on resize
  autocmd VimResized * exe 'normal! \<c-w>='
  autocmd BufRead *.vim,.*vimrc set foldenable foldmethod=marker foldlevel=0
  autocmd BufWritePost .vimrc,.vimrc.local,init.vim source %
  autocmd BufWritePost .vimrc.local source %
  " save all files on focus lost, ignoring warnings about untitled buffers
  autocmd FocusLost * silent! wa

  " make quickfix windows take all the lower section of the screen
  " when there are multiple windows open
  autocmd FileType qf wincmd J
  autocmd FileType qf nmap <buffer> q :q<cr>
augroup END
" }}}
call plug#begin('~/.local/share/nvim/plugged')
" Appearance {{{
set tabstop=2
set softtabstop=2
set expandtab
set shiftwidth=2
set smarttab
set autoindent 
set smartindent 
set wrap
set number
set foldmethod=syntax
set foldlevelstart=99
set foldnestmax=10
set nofoldenable
set foldlevel=1

set t_Co=256 " Explicitly tell vim that the terminal supports 256 colors

if &term =~ '256color'
    " disable background color erase
    set t_ut=
endif

" enable 24 bit color support if supported
if (has("termguicolors"))
  if (!(has("nvim")))
      let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif
  set termguicolors
endif

" Plug 'ajmwagar/vim-deus'
" Plug 'jacoborus/tender.vim'
Plug 'morhetz/gruvbox'
let g:gruvbox_contrast_dark = "soft"

Plug 'mhinz/vim-startify'
let g:startify_files_number = 5
let g:startify_change_to_dir = 0
let g:startify_custom_header = [ ]
let g:startify_relative_path = 1
let g:startify_use_env = 1

" Custom startup list, only show MRU from current directory/project
let g:startify_lists = [
\  { 'type': 'dir',       'header': [ 'Files '. getcwd() ] },
\  { 'type': function('helpers#startify#listcommits'), 'header': [ 'Recent Commits' ] },
\  { 'type': 'sessions',  'header': [ 'Sessions' ]       },
\  { 'type': 'bookmarks', 'header': [ 'Bookmarks' ]      },
\  { 'type': 'commands',  'header': [ 'Commands' ]       },
\ ]

let g:startify_commands = [
\   { 'up': [ 'Update Plugins', ':PlugUpdate' ] },
\   { 'ug': [ 'Upgrade Plugin Manager', ':PlugUpgrade' ] },
\ ]

autocmd User Startified setlocal cursorline
nmap <leader>st :Startify<cr>

set guicursor+=n:blinkon100-block-Cursor/lCursor
" }}}
" General Mappings {{{
let mapleader="\<SPACE>"
" remap esc
inoremap jk <esc>

" shortcut to save
nmap <leader><leader> :w<cr>

" set paste toggle
set pastetoggle=<leader>v

" clear highlighted search
noremap <leader>/ :set hlsearch! hlsearch?<cr>

inoremap <expr> <C-k> pumvisible() ? "\<C-P>" : "\<C-k>"
inoremap <expr> <C-j> pumvisible() ? "\<C-N>" : "\<C-j>"

" keep visual selection when indenting/outdenting
vmap < <gv
vmap > >gv

" Move lines around
nnoremap <A-j> :m .+1<cr>==
nnoremap <A-k> :m .-2<cr>==
inoremap <A-j> <Esc>:m .+1<cr>==gi
inoremap <A-k> <Esc>:m .-2<cr>==gi
vnoremap <A-j> :m '>+1<cr>gv=gv
vnoremap <A-k> :m '<-2<cr>gv=gv

" moving up and down work as you would expect
nnoremap <silent> j gj
nnoremap <silent> k gk
nnoremap <silent> ^ g^
nnoremap <silent> $ g$

map <silent> <C-h> <Plug>WinMoveLeft
map <silent> <C-j> <Plug>WinMoveDown
map <silent> <C-k> <Plug>WinMoveUp
map <silent> <C-l> <Plug>WinMoveRight

map <silent> <M-h> <C-W>H
map <silent> <M-j> <C-W>J
map <silent> <M-k> <C-W>K
map <silent> <M-l> <C-W>L

nmap <leader>z <Plug>Zoom
" }}}
" Git {{{
Plug 'tpope/vim-fugitive'
" }}}
" General Functionality {{{
Plug 'tomtom/tcomment_vim'
nmap <silent> <leader>gs :Gstatus<cr>
nmap <silent> <leader>gc :Git commit<cr>
" nmap <silent> <leader>gw :Gwrite<cr>
" nmap <silent> <leader>gr :Gread<cr>
" nmap <silent> <leader>ge :Gedit<cr>
" nmap <silent> <leader>gA :Git add .<cr>
" }}}
" coc {{{
Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions = [
      \ 'coc-json',
      \ 'coc-tsserver',
      \ 'coc-git',
      \ 'coc-eslint',
      \ 'coc-pairs',
      \ 'coc-prettier',
      \ 'coc-diagnostic'
      \ ]

autocmd CursorHold * silent call CocActionAsync('highlight')

" coc-prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile
nmap <leader>f :CocCommand prettier.formatFile<cr>

" coc-git
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)
nmap gs <Plug>(coc-git-chunkinfo)
nmap gu :CocCommand git.chunkUndo<cr>

"remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gh <Plug>(coc-doHover)

" diagnostics navigation
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" rename
nmap <silent> <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" organize imports
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

"tab completion
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" }}}
" ctrlspace {{{
Plug 'vim-ctrlspace/vim-ctrlspace'

if has('win32')
    let s:vimfiles = '~/vimfiles'
    let s:os   = 'windows'
else
    let s:vimfiles = '~/.vim'
    if has('mac') || has('gui_macvim')
        let s:os = 'darwin'
    else
    " elseif has('gui_gtk2') || has('gui_gtk3')
        let s:os = 'linux'
    endif
endif

let g:CtrlSpaceFileEngine = s:vimfiles . '/plugged/vim-ctrlspace' . '/bin/file_engine_' . s:os . '_amd64'

let g:CtrlSpaceSetDefaultMapping = 0
let g:CtrlSpaceDefaultMappingKey = "<Tab>"
let g:CtrlSpaceSaveWorkspaceOnExit = 1
let g:CtrlSpaceSaveWorkspaceOnSwitch = 1
let g:CtrlSpaceLoadLastWorkspaceOnStart = 0
let g:CtrlSpaceIgnoredFiles = '\v(tmp|temp|work|vendors)[\/]'
if executable("ag")
    let g:CtrlSpaceGlobCommand = 'ag -l --nocolor -g ""'
endif

nnoremap <silent><Tab> :CtrlSpace<CR>
nnoremap <silent><leader>o :CtrlSpace O<CR>

" }}}
" Files {{{
Plug 'tpope/vim-eunuch'

" }}}
call plug#end()

set undofile undodir="~/.local/share/nvim/undo"
colorscheme gruvbox
highlight SpecialKey ctermfg=19 guifg=#333333
highlight NonText ctermfg=19 guifg=#333333

syntax on
filetype on
filetype plugin on
filetype indent on

endif
