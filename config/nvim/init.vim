if (!exists('g:vscode'))
  " Vim-Plug
  " Install if not installed
  if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
  luafile ~/.config/nvim/init.lua
  let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.7 } }
endif
set clipboard=unnamed
