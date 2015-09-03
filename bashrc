# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
EDITOR='vim'

. ~/.git_term
. ~/.aliases
source ~/.git-prompt.sh
