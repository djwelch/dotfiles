export COLORTERM=truecolor
alias ls='ls --color=auto'

alias vim="nvim"
alias vi="nvim"
alias oldvim="vim"
alias vimdiff='nvim -d'
export EDITOR=nvim

[ -f ~/.config/zsh/history.zsh ] && source ~/.config/zsh/history.zsh

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# export PYENV_ROOT="$HOME/.pyenv"
fpath+=$HOME/.config/zsh/pure
fpath+=/usr/share/zsh/site-functions

path+=("$HOME/.local/bin")
path+=("$HOME/.rbenv/bin")
path+=("$PYENV_ROOT/bin")
export PATH
export PKG_CONFIG_PATH=~/.local/lib/pkgconfig
 
# alias newspaste="win32yank.exe -o >> ~/.config/newsboat/urls && vim + ~/.config/newsboat/urls"

# export BROWSER='/mnt/c/Program\ Files/Mozilla\ Firefox/firefox.exe'
# export PURE_PROMPT_SYMBOL=🐻
export PURE_PROMPT_SYMBOL=🐼
autoload -U promptinit; promptinit
prompt pure


[ -f ~/.config/zsh/motd.zsh ] && source ~/.config/zsh/motd.zsh

# eval "$(rbenv init -)"
# eval "$(pyenv init -)"
# source $HOME/.cargo/env

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
