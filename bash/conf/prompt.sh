#!/usr/bin/env bash

_date="date"
hash gdate 2>/dev/null && _date="gdate"

function ___aws_env () {
  if [[ -n "$__AWS_AUTHED_ENV" ]]; then
    echo -e "[$__AWS_AUTHED_ENV] "
  fi
}

function __conda_env () {
  condaEnv="$CONDA_DEFAULT_ENV"
  if [[ -n "$condaEnv" ]]; then
    if [[ "$condaEnv" == "base" ]]; then
      echo "($redFg$condaEnv$clr) "
    else
      echo "($condaEnv) "
    fi
  fi
}

function ___last_exit () {
  #shellcheck disable=SC2181
  if [[ "$1" == "0" ]]; then
    happy=$'\U0001F92F'
    echo -e "$happy "
    # echo -e "$greenFg"':)'
  else
    sad=$'\U0001F92c'
    echo -e "$sad "
    # echo -e "$redFg"':('
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

# Used to add execution timing to prompt, shamelessly stolen from
# https://tylercipriani.com/blog/2016/01/19/Command-Timing-Bash-Prompt/
function debug () {
    # do nothing if completing (running command completion)
    [[ -n "$COMP_LINE" ]] && return

    # dont cause a preexec for $PROMPT_COMMAND
    [[ "$BASH_COMMAND" = "$PROMPT_COMMAND" ]] && return

    startTime=$($_date +'%s')
}

# shellcheck disable=2155
function __prompt_command () {
  local exit="$?"
  PS1="\n"

  local red=196
  local green=35
  local blue=26
  local grey=238
  local khaki=100

  local sep=$'\ue0b0'
  local branchIcon=$'\ue0a0'

  local greenFg="\001$(tput setaf $green)\002"
  local redFg="\001$(tput setaf $red)\002"
  local greyFg="\001$(tput setaf $grey)\002"
  local blueFg="\001$(tput setaf $blue)\002"

  local greyBg="\001$(tput setab $grey)\002"
  local blueBg="\001$(tput setab $blue)\002"
  local greenBg="\001$(tput setab $green)\002"
  local khakiBg="\001$(tput setab $khaki)\002"

  # local clrFg="\[$(tput setaf 0)\]"
  # local clrBg="\[$(tput sgr0)\]"
  local clr='\[\e[0m\]'

  endTime=$($_date +'%s')
  elapsedTime=$(( endTime - startTime ))
  timeTaken=
  [[ $elapsedTime -ge 5 ]] && timeTaken=" $($_date -d'@'$(( endTime - startTime)) -u +'%T') "

  gitInfo=$(___git_info)
  if [[ -n "$gitInfo" ]]; then
    PS1+="$clr$greenBg $gitInfo $greenFg$blueBg$sep"
  fi
  PS1+="$clr$blueBg \W $blueFg$greyBg$sep"
  PS1+="$clr$greyBg $(___last_exit $exit)$timeTaken$clr$greyFg$sep"
  PS1+="$clr\n"
  PS1+="$(___aws_env)$(__conda_env)"
  PS1+="> "
}
trap 'debug' DEBUG
PROMPT_COMMAND=__prompt_command
