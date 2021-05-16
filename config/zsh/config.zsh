export TERM=putty
export COLORTERM=truecolor
alias ls='ls --color=auto'

alias vim="nvim"
alias vi="nvim"
alias oldvim="/usr/bin/vim"
alias vimdiff='nvim -d'
export EDITOR=nvim

alias xcopy="clip.exe"
alias pbcopy="clip.exe"
alias xclip="clip.exe"

alias vcxsrv="'/mnt/c/Program Files/VcXsrv/vcxsrv.exe' -ac -screen 0 800x600@1"

path+=("$HOME/.local/bin")
path+=("$HOME/.local/dotnet")
path+=("$HOME/.rbenv/bin")
path+=("$HOME/.yarn/bin")
path+=("$HOME/.config/yarn/global/node_modules/.bin")
path+=("$HOME/.cargo/bin")
path+=("/opt/texlive/2021/bin/x86_64-linux")
export PATH
export PKG_CONFIG_PATH=~/.local/lib/pkgconfig
export DOTNET_ROOT=/home/david/.local/dotnet

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

[ -f ~/.config/zsh/history.zsh ] && source ~/.config/zsh/history.zsh
[ -f ~/.config/zsh/motd.zsh ] && source ~/.config/zsh/motd.zsh

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

fpath+=$HOME/.config/zsh/pure
fpath+=/usr/share/zsh/site-functions

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

export PURE_PROMPT_SYMBOL=🐼
autoload -U promptinit; promptinit
autoload -Uz compinit
prompt pure
compinit

export PULSE_SERVER=tcp:$(grep nameserver /etc/resolv.conf | awk '{print $2}');
export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
export LIBGL_ALWAYS_INDIRECT=1

