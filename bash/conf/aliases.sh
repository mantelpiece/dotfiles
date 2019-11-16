#!/usr/bin/env bash

alias ll='/usr/local/bin/gls -alF --color=auto --group-directories-first'
alias la='/usr/local/bin/gls -A --color=auto --group-directories-first'

alias ls='/usr/local/bin/gls -h --color=auto --group-directories-first'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'


alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'


function cdiff() {
  colordiff -w -W 165 "$@" | less -R;
}

if [ -n "$(command -v pacman)" ]; then
  alias pacman="pacman --color always"
fi

if hash docker; then
  dcall() {
    docker rm $(docker ps -a -q)
    docker rmi $(docker images -q)
  }
fi

if hash docker-compose; then
  alias dcr='docker-compose run --rm'
  alias dcb='docker-compose build'
  alias dcu='docker-compose up'
  alias dcd='docker-compose down'

  dcrf() {
    docker-compose -f "$1" run --rm "${@:2}"
  }

  dcru() {
    docker-compose -f "$1" up --rm "${@:2}"
  }

  dcrd() {
    docker-compose -f "$1" down "${@:2}"
  }
fi

if hash conda; then
  alias cona='conda activate'
fi

if hash tmuxinator; then
  alias ts='tmuxinator start'
fi
