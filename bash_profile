# DON'T MODIFY THIS FILE
# Place new config in a separate file within ~/.bashrc.d/

# Source .bashrc if it exists (which will source everything in ~/.bashrc.d/)
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

# set alias
alias vi="vim"
alias vim="mvim -v"
alias grep="grep --color=auto"
alias ls='ls -GFh'
alias ll="ls -l"
alias lo="ls -o"
alias lh="ls -lh"
alias la="ls -la"
alias sl="ls"

# Bash completion will be installed in /usr/local/etc/bash_completion.d
# brew install bash-completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# Environment variables to set prompt format and color
export COLOR_BOLD="\[\e[1m\]"
export COLOR_DEFAULT="\[\e[0m\]"
export COLOR_WHITE="\[\033[m\]"
export COLOR_GREEN="\[\033[32m\]"
export COLOR_YELLOW="\[\033[33;1m\]"
export COLOR_RED="\[\e[31m\]"
export COLOR_BLUE="\[\033[36m\]"


# get current branch in git repo
function parse_git_branch() {
        BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
        if [ ! "${BRANCH}" == "" ]
        then
                STAT=$(parse_git_dirty)
                echo -e " [${BRANCH}${STAT}]"
        else
                echo ""
        fi
}

# get current status of git repo
function parse_git_dirty {
        status=$(git status 2>&1 | tee)
        dirty=$(echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?")
        untracked=$(echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?")
        ahead=$(echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?")
        newfile=$(echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?")
        renamed=$(echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?")
        deleted=$(echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?")
        bits=''
        if [ "${renamed}" == "0" ]; then
                bits=">${bits}"
        fi
        if [ "${ahead}" == "0" ]; then
                bits="*${bits}"
        fi
        if [ "${newfile}" == "0" ]; then
                bits="+${bits}"
        fi
        if [ "${untracked}" == "0" ]; then
                bits="?${bits}"
        fi
        if [ "${deleted}" == "0" ]; then
                bits="x${bits}"
        fi
        if [ "${dirty}" == "0" ]; then
                bits="!${bits}"
        fi
        if [ ! "${bits}" == "" ]; then
                echo " ${bits}"
        else
                echo ""
        fi
}

prompt_cmd () {
    LAST_STATUS=$?
    PS1=""
    # Test if user is root and set user color appropriately
    if [[ $(id -u) == 0 ]]
    then
        PS1+="$COLOR_RED"
    else
        PS1+="$COLOR_BLUE"
    fi
    PS1+="\u"
    PS1+="$COLOR_WHITE@"
    PS1+="$COLOR_GREEN\h"
    PS1+="$COLOR_WHITE:"
    PS1+="$COLOR_YELLOW\W"
    # Add git branch and status if applicable
    if type parse_git_branch > /dev/null 2>&1; then
        PS1+=$(parse_git_branch)
    fi
    # Test return code and colour the $ red if fail
    if [[ $LAST_STATUS = 0 ]]; then
        PS1+="$COLOR_WHITE"
    else
        PS1+="$COLOR_RED"
    fi
    PS1+='\$ '
    PS1+="$COLOR_WHITE"
    export PROMPT=$PS1
}

PROMPT_COMMAND='prompt_cmd'

# Set Default Editor
export EDITOR='vim'
export VISUAL='vim'

# Set ls Color
export LSCOLORS=ExFxBxDxCxegedabagacad
export CLICOLOR=1

export PATH="$PATH:/Users/steelz/Dev/android-sdk/platform-tools"
