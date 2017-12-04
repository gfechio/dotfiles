# don't load profile in scp session
[[ -z $PS1 && -z $SSH_TTY ]] && return

declare DESKTOP_HOSTNAME="HOSTNAME"
declare BASHRC_USERNAME=$USER
declare BASHRC_EMAIL="user@example.com"
declare COMPLETION_DIR="$HOME/.bash"
declare SERVERS_FILE="$COMPLETION_DIR/servers"
declare GIT_WORK_DIR="$HOME/Git"
declare PUPPET_DIR="$GIT_WORK_DIR/puppet"
declare BROWSER="chrome" # other supported values: chrome, firefox

unalias -a

export PATH=$PATH:/usr/local/bin/:/sbin:/usr/sbin:$HOME/bin:/usr/lib64/nagios/plugins/
export PERL5LIB=$PERL5LIB:/usr/local/git_tree/main/lib
export PATH="/usr/local/bin:$PATH"

export EDITOR=$(which vim)
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

HISTFILESIZE=20000
HISTSIZE=20000

if [ -f ~/.bash_pwd ]; then
    . ~/.bash_pwd
fi

if [ -f ~/.alias ]; then
    .  ~/.alias
fi

[[ -e .ssh/id_rsa ]] && { ssh-add -l &>/dev/null || ssh-add .ssh/id_rsa; }


[[ $ROLES =~ (dev|staging) ]] && { tmux attach || tmux new ; }

#### FUNCTIONS ####

function ch() {
    if [ $(hostname -s | grep puppet) ]
        then
        case $1 in
            prod)
                unset $PP_CH
                /bin/unlink ~/puppet
                /bin/ln -s ~/.ch_pp/puppet_prod ~/puppet
                export PP_CH='prod'
                cd ~/puppet
                ;;
            stg)
                unset $PP_CH
                /bin/unlink ~/puppet
                /bin/ln -s ~/.ch_pp/puppet_stg ~/puppet
                export PP_CH='stg'
                cd ~/puppet
                ;;
            show)
                echo $PP_CH
                #readlink -f  ~/puppet
                ;;
            create)
                /bin/mkdir ~/.ch_pp
                /bin/ln -s /###DIR ~/.ch_pp/puppet_stg
                ln -s /##DIR/ ~/.ch_pp/puppet_prod
                export $PP_CH=""
                ;;
            cd)
                cd ~/puppet
                ;;
            *)
                /bin/echo "Use create|prod|stg|show"
                ;;
        esac
    fi
}

fixssh() {
    eval $(tmux show-env -s |grep '^SSH_')
}


cst() {
    if [ -z "$HOSTS" ]; then
       HOSTS=${HOSTS:=$*}

       local hosts=( $HOSTS )
       local target="multissh-$((1 + RANDOM % 100))"

       tmux new-window -n "${target} " ssh ${hosts[0]}
       unset hosts[0];
       for i in "${hosts[@]}"; do
           tmux split-window -t :"${target}" -h  "ssh $i"
           tmux select-layout -t :"${target}" tiled > /dev/null
       done
       tmux select-pane -t 0
       tmux set-window-option -t :"${target}"  synchronize-panes on > /dev/null

    else
        echo "Clean var HOSTS"
        HOSTS=""
    fi
    HOSTS=""
    hosts=""
    target=""
}


__color_="\[\033[33m\]"
__time="\[\033[33m\][\t]"
__cur_location="\[\033[01;34m\]\w"
__git_branch='`git branch 2> /dev/null | grep -e ^* | sed -E s/^\\\\\*\ \(.+\)$/\(\\\\\1\)\ /`'
__prompt_tail="\[\033[34m\]$"
__last_color="\[\033[00m\]"
is_desktop && function color_my_prompt {
    local __salt_env_color="\[\033[01;37m\]"
    local __salt_env='`ch show`'
    local __user_and_host="\[\033[01;32m\]\u@\h"
    local __git_branch_color="\[\033[31m\]"
    export PS1="$__color_$__time$__user_and_host $__cur_location $__git_branch_color$__git_branch$__salt_env_color$__salt_env$__prompt_tail$__last_color "
} || function color_my_prompt {
    local __salt_env_color="\[\033[01;37m\]"
    local __salt_env='`ch show`'
    local __user_and_host="\[\033[0;31m\]\u@\h"
    local __git_branch_color="\[\033[33m\]"
    local __puppet_env_color="\[\033[01;37m\]"
    local __puppet_env='`ch show`'
    export PS1="$__color_$__time$__user_and_host $__cur_location $__git_branch_color$__git_branch$__salt_env_color$__salt_env$__prompt_tail$__last_color "
}
color_my_prompt

cores() { 
    for i in {0..255}
    do
        printf "\x1b[38;5;${i}mcolour${i}\x1b[0m\n" 
    done
}
