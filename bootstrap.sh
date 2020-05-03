# /bin/sh

mkdir -p ~/.local/{applications,bin}

# zsh {{{
sudo apt install zsh 
chsh -s $(which zsh)
# }}}

# fzf {{{
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
# }}}

# nvim {{{
curl -L --create-dirs -o ~/.local/applications/nvim.appimage \
  https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod a+x ~/.local/applications/nvim.appimage
ln -s -r ~/.local/applications/nvim.appimage ~/.local/bin/nvim 
# }}}

