{
  pkgs,
  nixpkgs,
  dotroot,
  ...
}: {
  imports = [
    ./vim.nix
    ./git.nix
    ./shell.nix
    ./misc.nix
    ./development.nix
    ./machines
  ];

  nix = {
    registry.nixpkgs.flake = nixpkgs;
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  # Home manager always manages itself
  programs.home-manager.enable = true;
}
