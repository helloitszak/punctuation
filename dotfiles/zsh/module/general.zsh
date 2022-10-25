#
# This file is the dumping ground for general initialization stuff
# A lot is cargo-culted from prezto
#

#
# Smart URLs
#

# This logic comes from an old version of zim. Essentially, bracketed-paste was
# added as a requirement of url-quote-magic in 5.1, but in 5.1.1 bracketed
# paste had a regression. Additionally, 5.2 added bracketed-paste-url-magic
# which is generally better than url-quote-magic so we load that when possible.
autoload -Uz is-at-least
if [[ ${ZSH_VERSION} != 5.1.1 ]]; then
  if is-at-least 5.2; then
    autoload -Uz bracketed-paste-url-magic
    zle -N bracketed-paste bracketed-paste-url-magic
  else
    if is-at-least 5.1; then
      autoload -Uz bracketed-paste-magic
      zle -N bracketed-paste bracketed-paste-magic
    fi
  fi
  autoload -Uz url-quote-magic
  zle -N self-insert url-quote-magic
fi

#
# General
#

setopt COMBINING_CHARS    # Combine zero-length punctuation characters (accents)
                          # with the base character.
setopt RC_QUOTES          # Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'.
unsetopt MAIL_WARNING     # Don't print a warning message if a mail file has been accessed.

# Correct commands.
setopt CORRECT

#
# Jobs
#

setopt LONG_LIST_JOBS     # List jobs in the long format by default.
setopt AUTO_RESUME        # Attempt to resume existing job before creating a new process.
setopt NOTIFY             # Report status of background jobs immediately.
unsetopt BG_NICE          # Don't run all background jobs at a lower priority.
unsetopt HUP              # Don't kill jobs on shell exit.
unsetopt CHECK_JOBS       # Don't report on jobs when shell exit.

#
# Termcap
#

# export LESS_TERMCAP_mb=$'\E[01;31m'      # Begins blinking.
# export LESS_TERMCAP_md=$'\E[01;31m'      # Begins bold.
# export LESS_TERMCAP_me=$'\E[0m'          # Ends mode.
# export LESS_TERMCAP_se=$'\E[0m'          # Ends standout-mode.
# export LESS_TERMCAP_so=$'\E[00;47;30m'   # Begins standout-mode.
# export LESS_TERMCAP_ue=$'\E[0m'          # Ends underline.
# export LESS_TERMCAP_us=$'\E[01;32m'      # Begins underline.

#
# Utility Functions
#

# Checks if a file can be autoloaded by trying to load it in a subshell.
function is-autoloadable {
  ( unfunction $1 ; autoload -U +X $1 ) &> /dev/null
}

# Checks if a name is a command, function, or alias.
function is-callable {
  (( $+commands[$1] || $+functions[$1] || $+aliases[$1] || $+builtins[$1] ))
}

# Checks a boolean variable for "true".
# Case insensitive: "1", "y", "yes", "t", "true", "o", and "on".
function is-true {
  [[ -n "$1" && "$1" == (1|[Yy]([Ee][Ss]|)|[Tt]([Rr][Uu][Ee]|)|[Oo]([Nn]|)) ]]
}

# Prints the first non-empty string in the arguments array.
function coalesce {
  for arg in $argv; do
    print "$arg"
    return 0
  done
  return 1
}
