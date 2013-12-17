##########################################################################
# This file is centrally managed, any manual changes will be OVERWRITTEN #
##########################################################################

# Load in the git branch prompt script.
source /etc/profile.d/git-prompt.sh

Black="\[\033[0;30m\]"        # Black
Red="\[\033[0;31m\]"          # Red
Green="\[\033[0;32m\]"        # Green
Yellow="\[\033[0;33m\]"       # Yellow
Blue="\[\033[0;34m\]"         # Blue
Purple="\[\033[0;35m\]"       # Purple
Cyan="\[\033[0;36m\]"         # Cyan
White="\[\033[0;37m\]"        # White

Color_Off="\[\033[0m\]"       # Text Reset

PS1="\[$Cyan\]\u@\h\[$Yellow\] \w\[$Purple\]\$(__git_ps1) \n\[$Color_Off\]# "
