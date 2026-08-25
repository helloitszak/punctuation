{
  lib,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "macos-funcs";
  version = "1.0.0";
  src = ./bin;

  # These are macOS-only: they drive Finder, Quick Look and Terminal/iTerm
  # via osascript/qlmanage. Guard so a build on Linux fails loudly rather
  # than installing scripts that can never work.
  meta.platforms = lib.platforms.darwin;

  # Deliberately non-hermetic: osascript, qlmanage and open live in the system
  # /usr/bin on macOS and are not packaged in nixpkgs, so the scripts keep
  # their `#!/usr/bin/env zsh` shebang and resolve everything from the system
  # rather than the store. There is nothing to build or wrap.
  dontPatchShebangs = true;

  installPhase = ''
    mkdir -p $out/bin
    install -m755 pfd pfs ql tab $out/bin
  '';
}
