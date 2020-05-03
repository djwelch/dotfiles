# /bin/sh

mkdir -p ~/.local/{applications,bin}
ssh-keygen -f ~/.ssh/github_id_rsa
sudo apt install unzip

# win32yank {{{
# requires https://www.microsoft.com/en-gb/download/confirmation.aspx?id=48145
curl -L --create-dirs -o ~/tmp/win32yank-x64.zip \
  https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
unzip ~/tmp/win32yank-x64.zip -d ~/tmp/win32yank-x64
cp ~/tmp/win32yank-x64/win32yank.exe /mnt/c/Users/djwel/Bin
cp ~/tmp/win32yank-x64/win32yank.exe ~/.local/bin/.
chmod a+x ~/.local/bin/win32yank.exe
rm -rf ~/tmp/win32yank-x64
# }}}

# zsh {{{
sudo apt install zsh 
chsh -s $(which zsh)
touch ~/.zshrc
curl -L --create-dirs -o ~/.config/zsh/history.zsh \
  https://raw.githubusercontent.com/djwelch/dotfiles/master/config/zsh/history.zsh
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

