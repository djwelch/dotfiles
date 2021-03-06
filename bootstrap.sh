# /bin/sh 
mkdir -p ~/.local/{applications,bin,opt}
[ ! -f ~/.ssh/github_id_rsa ] && ssh-keygen -f ~/.ssh/github_id_rsa
[ ! -f ~/.ssh/gitlab_id_rsa ] && ssh-keygen -f ~/.ssh/gitlab_id_rsa
[ ! -f ~/.ssh/remarkable_id_rsa ] && ssh-keygen -f ~/.ssh/remarkable_id_rsa

if ! type "yay" > /dev/null; then
  git clone https://aur.archlinux.org/yay.git ~/tmp/yay
  cd ~/tmp/yay
  makepkg -si
fi

yay -S xclip figlet blueberry zsh-completions xorg-xinput pyenv pyenv-virtualenv \
        figlet-fonts zlib lttng-ust fzf zsh unzip rsync cmake ninja ccls \
        boost boost-libs qt5-base community/rtaudio rustup dotnet-runtime dotnet-sdk

pyenv install 3.8.5
pyenv install 2.7.18

# # win32yank {{{
# # requires https://www.microsoft.com/en-gb/download/confirmation.aspx?id=48145
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

# lolcat {{{
if [ ! -f ~/.local/bin/lolcat ]; then
  git clone https://github.com/dosentmatter/lolcat.git ~/tmp/lolcat
  oldpath=`pwd`
  cd ~/tmp/lolcat
  make lolcat
  cp lolcat ~/.local/bin/.
  cd $oldpath
fi
rm -rf ~/tmp/lolcat
# }}}

# zsh {{{
[ ! -f ~/.zshrc ] && echo '[ -f ~/.config/zsh/config.zsh ] && source ~/.config/zsh/config.zsh' > ~/.zshrc
if [ ! -d ~/.config/zsh/pure ]; then
  git clone https://github.com/sindresorhus/pure.git ~/.config/zsh/pure
fi
# }}}

# nvim {{{
if [ ! -f ~/.local/bin/nvim ]; then
  curl -L --create-dirs -o ~/.local/applications/nvim.appimage \
    https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
  chmod a+x ~/.local/applications/nvim.appimage
  ~/.local/applications/nvim.appimage --appimage-extract
  mv squashfs-root ~/.local/nvim
  rm ~/.local/bin/nvim
  ln -s -r ~/.local/nvim/AppRun ~/.local/bin/nvim 
fi
# }}}

# # nvm {{{
 if [ ! -d ~/.nvm ]; then
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
   curl -o- -L https://yarnpkg.com/install.sh | bash
 fi
# # }}}
#
# if [ ! -f ~/.local/bin ]; then
# curl -L --create-dirs -o ~/tmp/jetbrains-toolbox-1.17.7018.tar.gz \
#   https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.17.7018.tar.gz
# tar -zxf ~/tmp/jetbrains-toolbox-1.17.7018.tar.gz -C ~/.local/opt
# ln -s -r ~/.local/opt/jetbrains-toolbox-1.17.7018/jetbrains-toolbox ~/.local/bin/jetbrains-toolbox
# fi

if [ ! -d ~/.local/dotnet]; then
  curl -L --create-dirs -o ~/tmp/dotnet-install.sh https://dot.net/v1/dotnet-install.sh
  chmod u+x ~/tmp/dotnet-install.sh
  ~/tmp/dotnet-install.sh --install-dir ~/.local/dotnet -channel Current -version latest
fi

# nvim {{{
if [ ! -f ~/.local/bin/nvim ]; then
  curl -L --create-dirs -o ~/tmp/omnisharp-linux-x64.tar.gz \
    https://github.com/OmniSharp/omnisharp-roslyn/releases/download/v1.37.3/omnisharp-linux-x64.tar.gz
  mkdir ~/.local/opt/omnisharp
  tar -xf ~/tmp/omnisharp-linux-x64.tar.gz -C ~/.local/opt/omnisharp
fi
# }}}

# rescript {{{
if [ ! -f ~/.local/bin/nvim ]; then
# curl -L --create-dirs -o ~/tmp/rescript-vscode.zip https://marketplace.visualstudio.com/_apis/public/gallery/publishers/chenglou92/vsextensions/rescript-vscode/1.0.8/vspackage
  git clone https://github.com/rescript-lang/rescript-vscode ~/tmp/rescript-vscode && cd ~/tmp/rescript-vscode && yarn && yarn compile
  cd server && yarn add chokidar
  cp -r ./out ~/.local/opt/rescript-lsp
  cp -rf ./node_modules ~/.local/opt/rescript-lsp/.
  cd ..
fi
# }}}
