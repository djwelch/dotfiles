# /bin/sh 
mkdir -p ~/.local/{applications,bin}
[ ! -f ~/.ssh/github_id_rsa ] && ssh-keygen -f ~/.ssh/github_id_rsa
[ ! -f ~/.ssh/gitlab_id_rsa ] && ssh-keygen -f ~/.ssh/gitlab_id_rsa

# zsh {{{
sudo pacman -S zsh
[ ! -f ~/.zshrc ] && echo '[ -f ~/.config/zsh/config.zsh ] && source ~/.config/zsh/config.zsh' > ~/.zshrc
if [ ! -d ~/.config/zsh/pure ]; then
  git clone https://github.com/sindresorhus/pure.git ~/.config/zsh/pure
fi
# }}}

# fzf {{{
sudo pacman -S fzf
# }}}

# nvim {{{
if [ ! -f ~/.local/bin/nvim ]; then
  curl -L --create-dirs -o ~/.local/applications/nvim.appimage \
    https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
  chmod a+x ~/.local/applications/nvim.appimage
  ln -s -r ~/.local/applications/nvim.appimage ~/.local/bin/nvim 
fi
# }}}

# nvm {{{
if [ ! -d ~/.nvm ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
  curl -o- -L https://yarnpkg.com/install.sh | bash
fi
# }}}
