PS1='\[\e]0;\u @ \h: \w\a\]\n\[\e[36m\]\u@\h - ks309566 \[\e[33m\]\w\[\e[0m\]\n$ '
alias l='ls -ltrh --color=always'
alias vi='vim'
alias dirtop="watch -d -n 1 'df; ls -FlAt $1'"
if [ $UID -gt 0 ] ; then
    linux_logo
fi

