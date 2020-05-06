# /bin/sh
sudo apt install unzip build-essential
mkdir -p ~/.local/{applications,bin}
[ ! -f ~/.ssh/github_id_rsa ] && ssh-keygen -f ~/.ssh/github_id_rsa
[ ! -f ~/.ssh/gitlab_id_rsa ] && ssh-keygen -f ~/.ssh/gitlab_id_rsa

# figlet {{{
if [ ! -f ~/.local/bin/figlet ]; then
  curl -L --create-dirs -o ~/tmp/figlet.tar.gz \
    ftp://ftp.figlet.org/pub/figlet/program/unix/figlet-2.2.5.tar.gz
  tar -xvf ~/tmp/figlet.tar.gz -C ~/tmp/
  pushd ~/tmp/figlet-2.2.5
  make
  cp {figlet,figlist,showfigfonts} ~/.local/bin/.
  popd
  curl -L --create-dirs -o ~/.local/share/figlet/puffy.flf \
    http://www.figlet.org/fonts/puffy.flf
  curl -L --create-dirs -o ~/.local/share/figlet/Small.flf \
    https://raw.githubusercontent.com/xero/figlet-fonts/master/Small.flf
  curl -L --create-dirs -o ~/.local/share/figlet/twopoint.flf \
    https://raw.githubusercontent.com/xero/figlet-fonts/master/twopoint.flf
  curl -L --create-dirs -o ~/.local/share/figlet/Standard.flf \
    https://raw.githubusercontent.com/xero/figlet-fonts/master/Standard.flf
fi
rm -f ~/tmp/figlet.tar.gz
rm -rf ~/tmp/figlet-2.2.5
# }}}

# lolcat {{{
if [ ! -f ~/.local/bin/lolcat ]; then
  git clone https://github.com/dosentmatter/lolcat.git ~/tmp/lolcat
  pushd ~/tmp/lolcat
  make lolcat
  cp lolcat ~/.local/bin/.
  popd
fi
rm -rf ~/tmp/lolcat
# }}}

# fonts {{{
if [ ! -d /mnt/c/Users/djwel/Fonts ]; then
  curl -L --create-dirs -o ~/tmp/FiraCode.zip \
    https://github.com/tonsky/FiraCode/releases/download/3.1/FiraCode_3.1.zip
  unzip ~/tmp/FiraCode.zip -d ~/tmp/FiraCode
  mkdir /mnt/c/Users/djwel/Fonts
  find ~/tmp/FiraCode -iname "*.ttf" | grep /ttf/ | xargs -I{} cp {} /mnt/c/Users/djwel/Fonts/.
  explorer.exe `wslpath -w /mnt/c/Users/djwel/Fonts`
fi
rm -f ~/tmp/FiraCode.zip
rm -rf ~/tmp/FiraCode
# }}}

# win32yank {{{
# requires https://www.microsoft.com/en-gb/download/confirmation.aspx?id=48145
if [ ! -f ~/.local/bin/win32yank.exe ]; then
  curl -L --create-dirs -o ~/tmp/win32yank-x64.zip \
    https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
  unzip ~/tmp/win32yank-x64.zip -d ~/tmp/win32yank-x64
  cp ~/tmp/win32yank-x64/win32yank.exe ~/.local/bin/.
  chmod a+x ~/.local/bin/win32yank.exe
fi
rm -f ~/tmp/win32yank-x64.zip
rm -rf ~/tmp/win32yank-x64
# }}}

# zsh {{{
sudo apt install zsh 
chsh -s $(which zsh)
[ ! -f ~/.zshrc ] && echo '[ -f ~/.config/zsh/config.zsh ] && source ~/.config/zsh/config.zsh' > ~/.zshrc

if [ ! -d ~/.config/zsh/pure ]; then
  git clone https://github.com/sindresorhus/pure.git ~/.config/zsh/pure
fi
# }}}

# fzf {{{
if [ ! -d ~/.fzf ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --update-rc --key-bindings --completion
fi
# }}}

# nvim {{{
if [ ! -f ~/.local/bin/nvim ]; then
  curl -L --create-dirs -o ~/.local/applications/nvim.appimage \
    https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
  chmod a+x ~/.local/applications/nvim.appimage
  ln -s -r ~/.local/applications/nvim.appimage ~/.local/bin/nvim 
fi
# }}}

