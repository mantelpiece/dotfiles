#!/bin/bash
alias ll='/usr/local/bin/gls -alF --color=auto --group-directories-first'
alias la='/usr/local/bin/gls -A --color=auto --group-directories-first'

alias ls='/usr/local/bin/gls -h --color=auto --group-directories-first'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'


alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'


function cdiff() {
  colordiff -w -W 165 $@ | less -R;
}

if [ -n "$(command -v pacman)" ]; then
  alias pacman="pacman --color always"
fi


if [ -n "$(command -v docker-compose)" ]; then
  alias dcr='docker-compose run --rm'

  dcrf() {
    docker-compose -f "$1" run ${@:2}
  }

fi
