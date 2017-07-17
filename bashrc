
# .bashrc

# ooo pretty colors
alias ls='ls --color=auto'
alias dir='dir --color=auto'

# git
alias g='git'
alias ga='git add -A'
alias gc='git commit -m"[WIP] auto"'
alias gpr='git pull --rebase'
alias gp='git push'
alias reset='git reset HEAD~1 --soft'

# tmux
alias take='tmux detach -a'
alias give='tmux detach'
alias stomp='tmux kill-session'

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific aliases and functions
EDITOR='vim'

#vimi
export VIMINIT='source $MYVIMRC'
export MYVIMRC='~/.vimrc'

# theme
export GTK_THEME=Adwaita:dark

# resize windows for applications
shopt -s checkwinsize

export GIT_AUTHOR_NAME="Sam Batschelet"
export GIT_AUTHOR_EMAIL=samb@endpoint.com
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"

alias vi='vim -u ~/.vimrc'

#eval $(ssh-agent)

if [ -n "$DESKTOP_SESSION" ];then
    eval $(gnome-keyring-daemon --start)
    export SSH_AUTH_SOCK
fi

export ACBUILD_BIN_DIR=~/acbuild/bin
export ETCDCTL_API=3
export ETCD_DEBUG=1
export ETCD_TEST_PORT=2379
export ETCD_TEST_HOST=127.0.0.1
export GOPATH="$HOME/go-packages"
export GOBIN="$GOPATH/bin"
export PATH="$HOME/.plenv/bin:$HOME/bin:/home/camp/bin:$HOME/go-packages/bin:$ACBUILD_BIN_DIR:$PATH"
eval "$(plenv init -)"

eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"
source <(kubectl completion bash)
