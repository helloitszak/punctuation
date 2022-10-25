#
# Options
#

setopt AUTO_CD              # Auto changes to a directory without typing cd.
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
setopt PUSHD_TO_HOME        # Push to home directory when no argument is given.
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt AUTO_NAME_DIRS       # Auto add variable-stored paths to ~ list.
setopt MULTIOS              # Write to multiple descriptors.
setopt EXTENDED_GLOB        # Use extended globbing syntax.
unsetopt CLOBBER            # Do not overwrite existing files with > and >>.
                            # Use >! and >>! to bypass.
autoload -U zmv

#
# Aliases
#

# Disable correction
alias cd='nocorrect cd'
alias cp='nocorrect cp'
alias ln='nocorrect ln'
alias mkdir='nocorrect mkdir'
alias rm='nocorrect rm'
alias mv='nocorrect mv'

# General directory and file releated aliases
alias po='popd'
alias pu='pushd'

alias mkdir="${aliases[mkdir]:-mkdir} -p"
alias rmi="${aliases[rm]:-rm} -i"
alias mvi="${aliases[mv]:-mv} -i"
alias cpi="${aliases[cp]:-cp} -i"
alias lni="${aliases[ln]:-ln} -i"

alias rm='rmi'
alias mv='mvi'
alias cp='cpi'
alias ln='lni'

#
# Colors on ls
#
if is-callable 'dircolors'; then
  # GNU Core Utilities
  alias ls='ls --group-directories-first'
  if [[ -s "$HOME/.dir_colors" ]]; then
    eval "$(dircolors --sh "$HOME/.dir_colors")"
  else
    eval "$(dircolors --sh)"
  fi

  alias ls="${aliases[ls]:-ls} --color=auto"
else
  # Define colors for BSD ls.
  export LSCOLORS='exfxcxdxbxGxDxabagacad'

  # Define colors for the completion system.
  export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'

  alias ls="${aliases[ls]:-ls} -G"
fi

#
# LS Quality of Life Aliases
#
alias l='ls -1A'         # Lists in one column, hidden files.
alias ll='ls -lh'        # Lists human readable sizes.
alias lr='ll -R'         # Lists human readable sizes, recursively.
alias la='ll -A'         # Lists human readable sizes, hidden files.
alias lm='la | "$PAGER"' # Lists human readable sizes, hidden files through pager.
alias lx='ll -XB'        # Lists sorted by extension (GNU only).
alias lk='ll -Sr'        # Lists sorted by size, largest last.
alias lt='ll -tr'        # Lists sorted by date, most recent last.
alias lc='lt -c'         # Lists sorted by date, most recent last, shows change time.
alias lu='lt -u'         # Lists sorted by date, most recent last, shows access time.
alias sl='ls'            # I often screw this up.


# If we have exa, make "xa" alias
if (( $+commands[xclip] )); then
  alias xa='exa'
fi

#
# Functions
#

# Makes a directory and changes to it.
function mkdcd {
  [[ -n "$1" ]] && mkdir -p "$1" && builtin cd "$1"
}

# Changes to a directory and lists its contents.
function cdls {
  builtin cd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}