pkgs: {
  git-gud = pkgs.callPackage ./git-gud/package.nix {};
  macos-funcs = pkgs.callPackage ./macos-funcs/package.nix {};
  punct = pkgs.callPackage ./punct/package.nix {};
}
