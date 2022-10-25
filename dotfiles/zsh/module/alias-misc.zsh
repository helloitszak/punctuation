#
# Misc Aliases
#

# Disable correction.
alias ack='nocorrect ack'
alias ebuild='nocorrect ebuild'
alias gcc='nocorrect gcc'
alias gist='nocorrect gist'
alias grep='nocorrect grep'
alias heroku='nocorrect heroku'
alias man='nocorrect man'
alias mysql='nocorrect mysql'

# Disable globbing.
alias bower='noglob bower'
alias fc='noglob fc'
alias find='noglob find'
alias ftp='noglob ftp'
alias history='noglob history'
alias locate='noglob locate'
alias rake='noglob rake'
alias rsync='noglob rsync'
alias scp='noglob scp'
alias sftp='noglob sftp'

# Enable colorization on grep
export GREP_COLOR='37;45'           # BSD.
export GREP_COLORS="mt=$GREP_COLOR" # GNU.
alias grep="${aliases[grep]:-grep} --color=auto"

# More human friendly df and du
alias df='df -kh'
alias du='du -kh'


# Neovim
function ovim {
    command vim "$@"
}

function vim {
    if type nvim > /dev/null 2>&1; then
        command nvim "$@"
    else
        command vim "$@"
    fi
}
