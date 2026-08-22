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
  ];

  nix = {
    registry.nixpkgs.flake = nixpkgs;
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  home.packages = with pkgs; [
    nvd
    punct
  ];

  # Home manager always manages itself
  programs.home-manager.enable = true;
}
