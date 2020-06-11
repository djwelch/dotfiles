# /bin/sh 
mkdir -p ~/.local/{applications,bin,opt}
[ ! -f ~/.ssh/github_id_rsa ] && ssh-keygen -f ~/.ssh/github_id_rsa
[ ! -f ~/.ssh/gitlab_id_rsa ] && ssh-keygen -f ~/.ssh/gitlab_id_rsa

sudo pacman -S xclip figlet
yay figlet-fonts

if [ ! -f ~/.local/bin/saml2aws ]; then
CURRENT_VERSION=2.26.1
wget https://github.com/Versent/saml2aws/releases/download/v${CURRENT_VERSION}/saml2aws_${CURRENT_VERSION}_linux_amd64.tar.gz
tar -xzvf saml2aws_${CURRENT_VERSION}_linux_amd64.tar.gz -C ~/.local/bin
chmod u+x ~/.local/bin/saml2aws
fi

# lolcat {{{
if [ ! -f ~/.local/bin/lolcat ]; then
  git clone https://github.com/dosentmatter/lolcat.git ~/tmp/lolcat
  oldpath=`pwd`
  cd ~/tmp/lolcat
  make lolcat
  cp lolcat ~/.local/bin/.
  cd oldpath
fi
rm -rf ~/tmp/lolcat
# }}}

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

if [ ! -f ~/.local/bin ]; then
curl -L --create-dirs -o ~/tmp/jetbrains-toolbox-1.17.7018.tar.gz \
  https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.17.7018.tar.gz
tar -zxf ~/tmp/jetbrains-toolbox-1.17.7018.tar.gz -C ~/.local/opt
ln -s -r ~/.local/opt/jetbrains-toolbox-1.17.7018/jetbrains-toolbox ~/.local/bin/jetbrains-toolbox
fi
