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
    # export GIT_PS1_SHOWUPSTREAM="verbose git"
    export GIT_PS1_SHOWUPSTREAM=

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


preexec () {
    timer=${timer:-$SECONDS}
}

function ___elapsed_time () {
    elapsedTime=$(( SECONDS - timer ))
    [[ $elapsedTime -ge 5 ]] && echo " $($_date -d'@'$elapsedTime -u +'%T') "
}

# Used to add execution timing to prompt, shamelessly stolen from
# https://tylercipriani.com/blog/2016/01/19/Command-Timing-Bash-Prompt/
function debug () {
    # do nothing if completing (running command completion)
    [[ -n "$COMP_LINE" ]] && return

    # dont cause a preexec for $PROMPT_COMMAND
    [[ "$BASH_COMMAND" = "$PROMPT_COMMAND" ]] && return

    # startTime=$($_date +'%s')
}

# shellcheck disable=2155
function __prompt_command () {
    local exit="$?"
    local timeTaken="123"

    local sep=$'\ue0b0'
    local branchIcon=$'\ue0a0'

    # if hash __git_ps1 2>/dev/null; then
    #     gitInfo=$(___git_info)
    #     if [[ -n "$gitInfo" ]]; then
    #       PS1+="$clr$greenBg $gitInfo $greenFg$blueBg$sep"
    #     fi
    # fi
    PS1="${nl}"
    PS1+="$clr$blueBg $workingDir $blueFg$greyBg$sep"
    PS1+="$clr$greyBg $(___last_exit $exit)$timeTaken$clr$greyFg$sep"
    PS1+="$clr${nl}"
    PS1+="$(___aws_env)$(__conda_env)"
    PS1+="> "
}

setopt PROMPT_SUBST

workingDir="%~"

red=196
# green=35
blue=26
grey=238
# khaki=100

sep=$'\ue0b0'
branchIcon=$'\ue0a0'

nl=$'\n'
# greenFg="%F{$green}"
redFg="%F{$red}"
greyFg="%F{$grey}"
blueFg="%F{$blue}"

greyBg="%K{$grey}"
blueBg="%K{$blue}"
# greenBg="%K{$green}"
# khakiBg="%K{$khaki}"

# shellcheck disable=SC2016
clr='%F{reset_color}%K{reset_color}'

#trap 'debug' DEBUG
nl=$'\n'
# shellcheck disable=SC2016
PROMPT='${nl}'
# shellcheck disable=SC2016
PROMPT+='$clr$blueBg $workingDir $blueFg$greyBg$sep'
# shellcheck disable=SC2016
PROMPT+='$clr$greyBg $(___last_exit $?)$(___elapsed_time)$clr$greyFg$sep$clr'
# shellcheck disable=SC2016
PROMPT+='${nl}$(___aws_env)$(__conda_env)'
PROMPT+='> '

