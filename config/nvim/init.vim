if (!exists('g:vscode'))
" Vim-Plug
  " Install if not installed
  if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
  luafile ~/.config/nvim/config.lua
  let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.7 } }
endif
set clipboard=unnamedplus

let g:clipboard = {
    \   'name': 'myClipboard',
    \   'copy': {
    \      '+': 'win32yank -i',
    \      '*': 'win32yank -i',
    \    },
    \   'paste': {
    \      '+': 'win32yank -o',
    \      '*': 'win32yank -o',
    \   },
    \   'cache_enabled': 1,
    \ }

function! ClangFormatonsave()
  let l:formatdiff = 1
  pyf /usr/share/clang/clang-format.py
endfunction
autocmd BufWritePre *.h,*.hpp,*.cc,*.cpp,*.c call ClangFormatonsave()

let g:python3_host_prog  = '/home/david/.pyenv/versions/3.8.5/bin/python3'
let g:python_host_prog  = '/home/david/.pyenv/versions/2.7.18/bin/python2'

function! Guid()
python << EOF
import uuid, vim
vim.command("normal i" + str(uuid.uuid4()) )
EOF
endfunction

map <m-g> :call Guid() <cr>

nmap <Leader>pp <Plug>(Prettier)
let g:prettier#config#print_width = '83'
let g:prettier#config#tab_width = '2'
let g:prettier#config#single_quote = 'true'
let g:prettier#config#trailing_comma = 'all'

autocmd TermOpen * setlocal nonumber norelativenumber

let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=2
let g:tex_conceal='abdmg'

autocmd BufNewFile,BufRead *.tex,*.sty,*.cls set tw=74

hi Conceal guibg=material guifg=material
