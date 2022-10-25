#
# Defines environment variables.
# As a reminder, zshenv runs in interactive, non-interactive and script modes.
#

# Initialization
declare -A PUNC
PUNC[ZSH]="$ZDOTDIR"

# Before anything else, initialize Nix if we have one. This will automatically only load once and depending on the
# environment it might be injected before we get here.
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# Set up home-manager too
if [ -f "/etc/profiles/per-user/${USER}/etc/profile.d/hm-session-vars.sh" ]; then
    # On NixOS with flakes, it seems the user profile is in
    # /etc/profiles/per-user/
    . "/etc/profiles/per-user/${USER}/etc/profile.d/hm-session-vars.sh"
elif [ -f "${NIX_USER_PROFILE_DIR}/profile/etc/profile.d/hm-session-vars.sh" ]; then
    # On non-NixOS, this might be the correct path? The path is almost
    # entirely empty on NixOS.
    . "${NIX_USER_PROFILE_DIR}/profile/etc/profile.d/hm-session-vars.sh"
elif [ -f "${HOME}/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
    # This is a fallback for non-NixOS, where the previous variable
    # may not always be set.
    . "${HOME}/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi
