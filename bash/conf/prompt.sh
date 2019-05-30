#!/usr/bin/env bash

function ___last_exit () {
  #shellcheck disable=SC2181
  if [[ "$1" == "0" ]]; then
    echo -e "$greenFg"':)'
  else
    echo -e "$redFg"':('
  fi
}

function ___git_info () {
  export GIT_PS1_SHOWDIRTYSTATE=true # '*' for unstaged and '+' for staged changes
  export GIT_PS1_SHOWSTASHSTATE=true # '$' indicates non-empty stash
  export GIT_PS1_SHOWUPSTREAM="verbose git"

  local gitInfo
  gitInfo=$(__git_ps1)
  if [[ -n "$gitInfo" ]]; then
    local _gitInfo
    _gitInfo=$(<<<"$gitInfo" sed -E 's/( \(|\)| u=)//g')
    #_gitInfo="$gitInfo"
    echo -e "$branchIcon $_gitInfo"
  else
    echo ""
  fi
}

# shellcheck disable=2155
function __prompt_command () {
  local exit="$?"
  PS1=""

  local red=196
  local green=35
  local blue=26
  local grey=238

  local sep=$'\ue0b0'
  local branchIcon=$'\ue0a0'

  local greenFg="\001$(tput setaf $green)\002"
  local redFg="\001$(tput setaf $red)\002"
  local greyFg="\001$(tput setaf $grey)\002"
  local blueFg="\001$(tput setaf $blue)\002"

  local greyBg="\001$(tput setab $grey)\002"
  local blueBg="\001$(tput setab $blue)\002"
  local greenBg="\001$(tput setab $green)\002"

  # local clrFg="\[$(tput setaf 0)\]"
  # local clrBg="\[$(tput sgr0)\]"
  local clr='\[\e[0m\]'

  gitInfo=$(___git_info)
  if [[ -n "$gitInfo" ]]; then
    PS1+="$clr$greenBg $gitInfo $greenFg$blueBg$sep"
  fi
  PS1+="$clr$blueBg \W $blueFg$greyBg$sep"
  PS1+="$clr$greyBg $(___last_exit $exit) $clr$greyFg$sep"
  PS1+="$clr "
}
PROMPT_COMMAND=__prompt_command
