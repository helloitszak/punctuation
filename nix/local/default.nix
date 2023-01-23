{...}: {
  overlay = (
    self: super: let
      sources = self.callPackage ./_sources/generated.nix {};
      callPackage = self.lib.callPackageWith (self // {inherit sources;});
    in {
      local = {
        inherit sources;
        git-gud = callPackage ./git-gud/default.nix {};
        proxmark3-rrg = callPackage ./proxmark3/proxmark3-rrg.nix {};
      };
    }
  );
}
