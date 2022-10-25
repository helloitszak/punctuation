
# Source Prezto.
# if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
#   source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
# fi

PLUGIN_DIR="${PUNC[ZSH]}/plugins"

# Load misc initialization stuff
source "${PUNC[ZSH]}/module/general.zsh"
source "${PLUGIN_DIR}/zsh-async/async.zsh"

source "${PUNC[ZSH]}/module/functions.zsh"
source "${PUNC[ZSH]}/module/prompt.zsh"

# Setup prezto's terminal module
zstyle ':prezto:module:terminal' auto-title 'yes'
zstyle ':prezto:module:terminal:window-title' format '%n@%m: %s'
zstyle ':prezto:module:terminal:tab-title' format '%m: %s'
source "${PUNC[ZSH]}/module/terminal.zsh"

# Setup keybindings
zstyle ':prezto:module:editor' key-bindings 'emacs'
source "${PUNC[ZSH]}/module/editor.zsh"

source "${PUNC[ZSH]}/module/alias-misc.zsh"
source "${PUNC[ZSH]}/module/directory.zsh"
source "${PUNC[ZSH]}/module/history.zsh"

# OS Specific stuff
source "${PUNC[ZSH]}/module/gui-interaction.zsh"
# NB: os-specific functions are set in zshenv

# Make completion last, I think this is required?
source "${PUNC[ZSH]}/module/completion.zsh"

# This has to be last to work
source "${PLUGIN_DIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "${PLUGIN_DIR}/zsh-history-substring-search/zsh-history-substring-search.zsh"
