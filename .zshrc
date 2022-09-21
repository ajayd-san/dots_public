
#config for zsh, required path : $HOME/.config/zsh (or in $HOME/.zshrc)

#-----------
#adding stuff to $PATH
#-----------
export PIPENV_VENV_IN_PROJECT=1
export PYENV_ROOT="$HOME/.pyenv"
export PATH=$PATH:/home/default/.local/bin:$PYENV_ROOT:/home/default/.local/bin/pylsp
#initialize autojump
[ -f "/usr/share/autojump/autojump.zsh" ] && source "/usr/share/autojump/autojump.zsh"

autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
# auto complete with with case insensitivity
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zmodload zsh/complist
compinit


#-----------
#use vim keys in tab complete menu
#-----------
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'left' vi-backward-char
bindkey -M menuselect 'down' vi-down-line-or-history
bindkey -M menuselect 'up' vi-up-line-or-history
bindkey -M menuselect 'right' vi-forward-char
# Fix backspace bug when switching modes
bindkey "^?" backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

# ci", ci', ci`, di", etc
autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
  for c in {a,i}{\',\",\`}; do
    bindkey -M $m $c select-quoted
  done
done

# ci{, ci(, ci<, di{, etc
autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $m $c select-bracketed
  done
done
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
precmd() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

#-----------
#prompt stuff
#-----------
autoload -Uz promptinit
promptinit
prompt spaceship
SPACESHIP_VI_MODE_SHOW=false


#-------------
#history stuff
#-------------
#
HISTFILE=~/.config/zsh/histfile
HISTSIZE=10000
SAVEHIST=10000

autoload -Uz history-beginning-search-menu
zle -N history-beginning-search-menu
bindkey '^X^X' history-beginning-search-menu

#------------
#Variables
#------------

export BROWSER="brave"
export EDITOR="nvim"

[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"


#-----------
#source syntax highlighting
#-----------

if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
        . /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
        . /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

eval $(thefuck --alias)
