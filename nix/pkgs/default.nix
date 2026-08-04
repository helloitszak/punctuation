# {...}: {
#   overlay = (
#     self: super: let
#       sources = self.callPackage ./_sources/generated.nix {};
#       callPackage = self.lib.callPackageWith (self // {inherit sources;});
#     in {
#       local-sources = sources;
#       local = {
#         git-gud = callPackage ./git-gud/default.nix {};
#         rpiboot = callPackage ./rpiboot/rpiboot.nix {};
#       };
#     }
#   );
# }
pkgs: {
  git-gud = pkgs.callPackage ./git-gud/package.nix {};
  # proxmark3 = pkgs.callPackage ./proxmark3/package.nix {};
}
