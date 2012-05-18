shopt -s histappend
HISTFILE=~/.bash_history
HISTSIZE=10000
HISTFILESIZE=999999
# Do not let the users enter commands that are ignored
# in the history file
HISTIGNORE=""
HISTCONTROL=""
HISTTIMEFORMAT="%F %T "
readonly HISTFILE
readonly HISTSIZE
readonly HISTFILESIZE
readonly HISTIGNORE
readonly HISTCONTROL
readonly HISTTIMEFORMAT
export HISTFILE HISTSIZE HISTFILESIZE HISTIGNORE HISTCONTROL HISTTIMEFORMAT

