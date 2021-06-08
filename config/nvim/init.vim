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

nmap <Leader>pp <Plug>(Prettier)
let g:prettier#config#print_width = '83'
let g:prettier#config#tab_width = '2'
let g:prettier#config#single_quote = 'true'
let g:prettier#config#trailing_comma = 'all'

autocmd TermOpen * setlocal nonumber norelativenumber

let g:vimtex_indent_ignored_envs = ['document', 'verbatim', 'lstlisting', 'frame', 'example', 'theorem', 'lemma', 'begin']
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'
"let g:latex_indent_enabled = 0

" autocmd BufNewFile,BufRead *.tex,*.sty,*.cls set tw=74

function! s:insert_include_guard()
  let s:uuid=system('uuidgen')
  let s:uuid=strpart(s:uuid, 0, strlen(s:uuid)-1)
  let s:uuid=substitute(s:uuid, '[a-f]', '\u\0', 'g')
  let s:uuid=substitute(s:uuid, '\-', '_', 'g')
  let s:uuid=substitute(expand('%:t:r'), '[a-z]', '\U\0', 'g').'_'.s:uuid
  call append(0, '#ifndef '.s:uuid)
  call append(1, '#define '.s:uuid)
  call append('$', '#endif //'.s:uuid)
endfunction
command! -nargs=0 InsertIncludeGuard call s:insert_include_guard()

map <m-g> :InsertIncludeGuard<cr>

