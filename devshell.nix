{
  pkgs,
  inputs,
  system,
  ...
}: let
  # pkgs = nixpkgs.legacyPackages.${system};
  punct = (import ./nix/pkgs pkgs).punct;
in
  pkgs.mkShell {
    buildInputs = with pkgs; [
      alejandra
      inputs.home-manager.packages.${system}.default
      # punct itself
      punct
      # punct development tooling
      python3
      uv
      ruff
      basedpyright
    ];
  }
