{
  pkgs,
  lib,
  ...
}:
# macOS-only conveniences. Everything here is a no-op on Linux hosts.
lib.mkIf pkgs.stdenv.isDarwin {
  # Finder / Quick Look / new-tab helpers, ported from the old Prezto `osx`
  # functions to standalone executables (see nix/pkgs/macos-funcs).
  home.packages = [pkgs.macos-funcs];

  # The ergonomic wrappers that used to live in gui-interaction.zsh. These are
  # the bits that must run in the current shell (cd/pushd), so they stay as
  # shell aliases rather than moving into the package.
  programs.zsh.shellAliases = {
    o = "open";
    cdf = ''cd "$(pfd)"'';
    pushdf = ''pushd "$(pfd)"'';
    pbc = "pbcopy";
    pbp = "pbpaste";
  };
}
