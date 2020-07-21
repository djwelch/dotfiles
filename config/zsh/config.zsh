export COLORTERM=truecolor
alias ls='ls --color=auto'

alias vim="nvim"
alias vi="nvim"
alias oldvim="vim"
alias vimdiff='nvim -d'
export EDITOR=nvim

path+=("$HOME/.local/bin")
path+=("$HOME/.local/dotnet")
path+=("$HOME/.rbenv/bin")
path+=("$HOME/.yarn/bin")
path+=("$HOME/.config/yarn/global/node_modules/.bin")
export PATH
export PKG_CONFIG_PATH=~/.local/lib/pkgconfig
export DOTNET_ROOT=/home/david/.local/dotnet

eval "$(pyenv init -)"

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
