pkgs: {
  git-gud = pkgs.callPackage ./git-gud/package.nix {};
  punct = pkgs.callPackage ./punct/package.nix {};
}
