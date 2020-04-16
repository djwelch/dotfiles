# /bin/sh

# nvim {{{
curl -L --create-dirs -o ~/.local/applications/nvim.appimage \
  https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod a+x ~/.local/applications/nvim.appimage
ln -s -r ~/.local/applications/nvim.appimage ~/.local/bin/nvim 
# }}}
