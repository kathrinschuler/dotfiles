# Step 3.

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# load Solarized palette automaticly
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# some more git aliases
alias gits="git status -sb"

# Normal Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[00;38;5;33m'   # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[01;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[01;38;5;33m'   # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

NC="\e[m"               # Color Reset
Color_Off=$NC

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

function job_color()
{
    if [ $(jobs -s | wc -l) -gt "0" ]; then
        echo -en ${Red}
    elif [ $(jobs -r | wc -l) -gt "0" ] ; then
        echo -en ${Green}
    fi
}

function set_ps1()
{
    COLOUR_DISABLED=$DISABLE_GIT_PS1_COLOUR
    if [ -f .disable_git_ps1_colour ]; then
        COLOUR_DISABLED=1
    fi

    # capture the exit status of the last command
    EXIT="$?"
    PROMPT_PS1=""

    if [ $EXIT -eq 0 ]; then
        PROMPT_PS1+="\[$Yellow\][\A]\[$Color_Off\] "; #The \A was \! before (\! shows the command history number, \A shows the time in HH:mm)
    else
        PROMPT_PS1+="\[$Red\][\A]\[$Color_Off\] ";
    fi

    PROMPT_PS1+="\[$Purple\]\h\[$Color_Off\]:\[$Blue\]\w\[$Color_Off\]\n"

    Color_On=""
    # check if inside git repo
    if [[ $COLOUR_DISABLED -eq 1 ]]; then
        local Color_On=$Purple
    else
        local git_status="`git status -unormal 2>&1`"
        if ! [[ "$git_status" =~ Not\ a\ git\ repo ]]; then
            # parse the porcelain output of git status
            if [[ "$git_status" =~ nothing\ to\ commit ]]; then
                local Color_On=$Green
            elif [[ "$git_status" =~ nothing\ added\ to\ commit\ but\ untracked\ files\ present ]]; then
                local Color_On=$Cyan
            else
                local Color_On=$Red
            fi
        fi
    fi

    # add the result to prompt
    PROMPT_PS1+="\[$Color_On\]`__git_ps1 "(%s)"`\[$Color_Off\]"

    # prompt $ or # for root
    PROMPT_PS1+="\[\$(job_color)\]\$\[$Color_Off\] "
    TITLE_PS1="\[\033]0;\u@\h: \w\007\]"
    PS1=${PROMPT_PS1}${TITLE_PS1}
}
function prompt_command()
{
    # must be run first, to get last command's status
    set_ps1

    # history -a
    # history -c
    # history -r

}
# make screen write to histfile all the time
export PROMPT_COMMAND=prompt_command

# mount shared folder
#if [[ ! $(mount | grep ubuntu_shared) ]]; then
#    echo "Mounting shared drive.."
#    sudo mount -t vboxsf ubuntu_shared ~/shared
#fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# use z:
. /home/kathrin/.z_dir/z.sh
