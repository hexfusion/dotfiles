# .bash_profile

# User specific environment and startup programs

# camps
#PATH=$PATH:$HOME/bin:/home/camp/bin

#export PLENV_ROOT=/home/camp/.plenv
#export PATH="/home/camp/.plenv/bin:$PATH"
#eval "$(plenv init -)"

alias ls='ls --color=auto'
alias dir='dir --color=auto'

#Ondir stuff this helps maintain env for camps
#cd()
#{
#        builtin cd "$@" && eval "`ondir \"$OLDPWD\" \"$PWD\"`"
#}

#pushd()
#{
#        builtin pushd "$@" && eval "`ondir \"$OLDPWD\" \"$PWD\"`"
#}
#
#popd()
#{
#        builtin popd "$@" && eval "`ondir \"$OLDPWD\" \"$PWD\"`"
#}

# Run ondir on login
#eval "`ondir /`"

EDITOR='vim'

. ~/.git_term
. ~/.aliases
source ~/.git-prompt.sh
